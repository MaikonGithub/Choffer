import Foundation
import SwiftUI
import Combine

/// ViewModel para a tela de registro de usuário
/// Gerencia o estado da UI e coordena com AuthenticationService
@MainActor
class RegistrationViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Nome completo do usuário
    @Published var fullName: String = ""
    
    /// CPF do usuário (opcional)
    @Published var cpf: String = ""
    
    /// Número de telefone do usuário
    @Published var phoneNumber: String = ""
    
    /// Senha do usuário
    @Published var password: String = ""
    
    /// Confirmação da senha
    @Published var confirmPassword: String = ""
    
    /// Estado de carregamento
    @Published var isLoading: Bool = false
    
    /// Mensagem de erro
    @Published var errorMessage: String?
    
    /// Mensagem de sucesso
    @Published var successMessage: String?
    
    /// Flag para navegar para verificação SMS
    @Published var shouldNavigateToPhoneVerification: Bool = false
    
    /// ID da verificação SMS
    @Published var verificationID: String = ""
    
    // MARK: - Private Properties
    
    /// Serviço de autenticação
    private let authService: AuthenticationService
    
    /// Cancellables para gerenciar subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(authService: AuthenticationService? = nil) {
        self.authService = authService ?? AuthenticationService()
    }
    
    // MARK: - Public Methods
    
    /// Inicia o processo de registro
    func startRegistration() {
        // Limpar mensagens anteriores
        clearMessages()
        
        // Validar campos
        guard validateFields() else {
            return
        }
        
        // Iniciar carregamento
        isLoading = true
        
        // Formatar telefone para Firebase
        let formattedPhone = FormattingUtils.phoneFirebase(phoneNumber)
        
        print("📱 Iniciando registro para: \(formattedPhone)")
        
        // Chamar AuthenticationService
        authService.startRegistration(phoneNumber: phoneNumber) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let verificationID):
                    print("✅ SMS enviado com sucesso")
                    self?.verificationID = verificationID
                    self?.successMessage = "SMS enviado! Verifique seu telefone."
                    self?.shouldNavigateToPhoneVerification = true
                    
                case .failure(let error):
                    print("❌ Erro ao enviar SMS: \(error)")
                    self?.errorMessage = self?.getErrorMessage(for: error)
                }
            }
        }
    }
    
    /// Completa o registro com código SMS
    func completeRegistration(verificationCode: String) {
        // Limpar mensagens anteriores
        clearMessages()
        
        // Validar código
        guard !verificationCode.isEmpty else {
            errorMessage = "Por favor, digite o código de verificação."
            return
        }
        
        // Iniciar carregamento
        isLoading = true
        
        // Preparar dados do usuário
        let userData = RegistrationData(
            phoneNumber: phoneNumber,
            fullName: FormattingUtils.nameClean(fullName),
            cpf: cpf.isEmpty ? nil : FormattingUtils.cpfRaw(cpf)
        )
        
        print("📱 Completando registro com código: \(verificationCode)")
        
        // Chamar AuthenticationService
        authService.completeRegistration(
            verificationID: verificationID,
            verificationCode: verificationCode,
            userData: userData
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let user):
                    print("✅ Registro concluído com sucesso: \(user.fullName)")
                    self?.successMessage = "Conta criada com sucesso!"
                    // Navegação será gerenciada pelo ContentView via AuthenticationService
                    
                case .failure(let error):
                    print("❌ Erro ao completar registro: \(error)")
                    self?.errorMessage = self?.getErrorMessage(for: error)
                }
            }
        }
    }
    
    /// Limpa todas as mensagens
    func clearMessages() {
        errorMessage = nil
        successMessage = nil
    }
    
    /// Limpa todos os campos
    func clearFields() {
        fullName = ""
        cpf = ""
        phoneNumber = ""
        password = ""
        confirmPassword = ""
        clearMessages()
    }
    
    // MARK: - Private Methods
    
    /// Valida todos os campos do formulário
    private func validateFields() -> Bool {
        // Validar nome
        let cleanName = FormattingUtils.nameClean(fullName)
        if cleanName.isEmpty {
            errorMessage = "Por favor, digite seu nome completo."
            return false
        }
        
        if cleanName.count < 2 {
            errorMessage = "Nome deve ter pelo menos 2 caracteres."
            return false
        }
        
        // Validar telefone
        if !FormattingUtils.phoneValid(phoneNumber) {
            errorMessage = "Por favor, digite um telefone válido."
            return false
        }
        
        // Validar senha
        if password.isEmpty {
            errorMessage = "Por favor, digite uma senha."
            return false
        }
        
        if password.count < 6 {
            errorMessage = "Senha deve ter pelo menos 6 caracteres."
            return false
        }
        
        // Validar confirmação de senha
        if confirmPassword.isEmpty {
            errorMessage = "Por favor, confirme sua senha."
            return false
        }
        
        if password != confirmPassword {
            errorMessage = "As senhas não coincidem."
            return false
        }
        
        // Validar CPF (se preenchido)
        if !cpf.isEmpty && !FormattingUtils.cpfValid(cpf) {
            errorMessage = "Por favor, digite um CPF válido."
            return false
        }
        
        return true
    }
    
    /// Converte erro do Firebase em mensagem amigável
    private func getErrorMessage(for error: Error) -> String {
        if let authError = error as? AuthenticationError {
            return authError.localizedDescription
        }
        
        // Erros específicos do Firebase
        let nsError = error as NSError
        switch nsError.code {
        case 17010: // Invalid phone number
            return "Número de telefone inválido."
        case 17011: // Invalid verification code
            return "Código de verificação inválido."
        case 17020: // Invalid verification ID
            return "Sessão de verificação expirada. Tente novamente."
        case 17025: // Too many requests
            return "Muitas tentativas. Aguarde alguns minutos."
        case 17034: // Quota exceeded
            return "Limite de SMS excedido. Tente novamente mais tarde."
        default:
            return "Ocorreu um erro inesperado. Tente novamente."
        }
    }
}

