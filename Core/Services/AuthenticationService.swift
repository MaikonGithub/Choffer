import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import Combine

/// Serviço de autenticação Firebase para o aplicativo Choffer
/// Gerencia login, registro e verificação por telefone + SMS
@MainActor
class AuthenticationService: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Usuário atual logado
    @Published var currentUser: User?
    
    /// Estado de autenticação
    @Published var isAuthenticated = false
    
    /// Estado de carregamento
    @Published var isLoading = false
    
    // MARK: - Private Properties
    
    /// Instância do Firestore
    private let db = Firestore.firestore()
    
    /// Nome da coleção de usuários no Firestore
    private let usersCollection = "users"
    
    /// Cancellables para gerenciar subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        setupAuthStateListener()
    }
    
    // MARK: - Auth State Management
    
    /// Configura o listener para mudanças no estado de autenticação
    private func setupAuthStateListener() {
        _ = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                if let user = user {
                    await self?.loadUserData(uid: user.uid)
                } else {
                    self?.currentUser = nil
                    self?.isAuthenticated = false
                }
            }
        }
    }
    
    /// Carrega os dados do usuário do Firestore
    private func loadUserData(uid: String) async {
        do {
            let document = try await db.collection(usersCollection).document(uid).getDocument()
            
            if let data = document.data(),
               let user = User.fromFirestore(data: data) {
                self.currentUser = user
                self.isAuthenticated = true
            } else {
                await signOut()
            }
        } catch {
            print("❌ Erro ao carregar usuário: \(error)")
            await signOut()
        }
    }
    
    // MARK: - Registration Flow
    
    /// Inicia o processo de registro enviando SMS
    /// - Parameters:
    ///   - phoneNumber: Número de telefone (formato brasileiro: 11999999999)
    ///   - completion: Callback com resultado (verificationID ou erro)
    func startRegistration(phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Formatar para E.164: +55DDNNNNNNNNN
        let formattedPhone = FormattingUtils.phoneFirebase(phoneNumber)
        
        print("🔧 Tentando enviar SMS para: \(formattedPhone)")
        
        // Usar callback-based para máxima compatibilidade
        PhoneAuthProvider.provider().verifyPhoneNumber(formattedPhone, uiDelegate: nil) { verificationID, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Erro ao enviar SMS: \(error)")
                    completion(.failure(error))
                } else if let verificationID = verificationID {
                    print("✅ SMS enviado com sucesso")
                    completion(.success(verificationID))
                } else {
                    print("❌ VerificationID é nil")
                    completion(.failure(AuthenticationError.unknown))
                }
            }
        }
    }
    
    /// Completa o registro verificando o código SMS
    /// - Parameters:
    ///   - verificationID: ID da verificação retornado pelo startRegistration
    ///   - verificationCode: Código SMS inserido pelo usuário
    ///   - userData: Dados do usuário para criação
    ///   - completion: Callback com resultado (User ou erro)
    func completeRegistration(
        verificationID: String,
        verificationCode: String,
        userData: RegistrationData,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let firebaseUser = result?.user else {
                    completion(.failure(AuthenticationError.unknown))
                    return
                }
                
                self?.createUserInFirestore(firebaseUser: firebaseUser, userData: userData, completion: completion)
            }
        }
    }
    
    /// Cria o documento do usuário no Firestore
    private func createUserInFirestore(
        firebaseUser: FirebaseAuth.User,
        userData: RegistrationData,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        let user = User(
            uid: firebaseUser.uid,
            phoneNumber: FormattingUtils.phoneFirebase(userData.phoneNumber),
            fullName: userData.fullName,
            cpf: userData.cpf
        )
        
        db.collection(usersCollection).document(firebaseUser.uid).setData(user.firestoreData) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    self?.currentUser = user
                    self?.isAuthenticated = true
                    completion(.success(user))
                }
            }
        }
    }
    
    // MARK: - Login Flow
    
    /// Realiza login do usuário
    /// - Parameters:
    ///   - phoneNumber: Número de telefone
    ///   - completion: Callback com resultado (User ou erro)
    func login(phoneNumber: String, completion: @escaping (Result<User, Error>) -> Void) {
        // Para login simples, verifica se usuário já está autenticado
        if let currentUser = Auth.auth().currentUser {
            Task {
                await loadUserData(uid: currentUser.uid)
                if let user = self.currentUser {
                    completion(.success(user))
                } else {
                    completion(.failure(AuthenticationError.userNotFound))
                }
            }
        } else {
            completion(.failure(AuthenticationError.userNotFound))
        }
    }
    
    // MARK: - Sign Out
    
    /// Realiza logout do usuário
    func signOut() async {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            isAuthenticated = false
        } catch {
            print("❌ Erro ao fazer logout: \(error)")
        }
    }
}

// MARK: - Supporting Types

/// Dados necessários para registro de um novo usuário
struct RegistrationData {
    let phoneNumber: String
    let fullName: String
    let cpf: String?
}

/// Erros customizados de autenticação
enum AuthenticationError: Error, LocalizedError {
    case invalidPhoneNumber
    case invalidVerificationCode
    case userNotFound
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidPhoneNumber:
            return "Número de telefone inválido."
        case .invalidVerificationCode:
            return "Código de verificação inválido."
        case .userNotFound:
            return "Usuário não encontrado."
        case .unknown:
            return "Ocorreu um erro inesperado. Tente novamente."
        }
    }
}

