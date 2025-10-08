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
        print("🔍 [DEBUG] Iniciando startRegistration()")
        
        // Limpar mensagens anteriores
        clearMessages()
        
        // Debug: Mostrar dados atuais
        print("🔍 [DEBUG] Dados do formulário:")
        print("   - Nome: '\(fullName)'")
        print("   - CPF: '\(cpf)'")
        print("   - Telefone: '\(phoneNumber)'")
        print("   - Senha: '\(password.isEmpty ? "vazia" : "preenchida")'")
        print("   - Confirmar Senha: '\(confirmPassword.isEmpty ? "vazia" : "preenchida")'")
        
        // Validar campos
        print("🔍 [DEBUG] Iniciando validação de campos...")
        guard validateFields() else {
            print("❌ [DEBUG] Validação de campos falhou")
            return
        }
        print("✅ [DEBUG] Validação de campos passou")
        
        // Iniciar carregamento
        isLoading = true
        
        // Formatar telefone para Firebase
        let formattedPhone = FormattingUtils.phoneFirebase(phoneNumber)
        print("🔍 [DEBUG] Telefone formatado para Firebase: '\(formattedPhone)'")
        
        // Validar formato final
        let rawPhone = FormattingUtils.phoneRaw(phoneNumber)
        print("🔍 [DEBUG] Telefone raw: '\(rawPhone)' (dígitos: \(rawPhone.count))")
        
        print("📱 Iniciando registro para: \(formattedPhone)")
        
        // Chamar AuthenticationService
        authService.startRegistration(phoneNumber: phoneNumber) { [weak self] result in
            DispatchQueue.main.async {
                print("🔍 [DEBUG] Callback do Firebase recebido")
                self?.isLoading = false
                
                switch result {
                case .success(let verificationID):
                    print("✅ SMS enviado com sucesso - VerificationID: \(verificationID)")
                    self?.verificationID = verificationID
                    self?.successMessage = "SMS enviado! Verifique seu telefone."
                    self?.shouldNavigateToPhoneVerification = true
                    print("🔍 [DEBUG] Navegação ativada: \(self?.shouldNavigateToPhoneVerification ?? false)")
                    
                case .failure(let error):
                    print("❌ Erro detalhado do Firebase:")
                    print("   - Tipo: \(type(of: error))")
                    print("   - Descrição: \(error.localizedDescription)")
                    print("   - NSError code: \((error as NSError).code)")
                    print("   - NSError domain: \((error as NSError).domain)")
                    print("   - NSError userInfo: \((error as NSError).userInfo)")
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
        print("🔍 [DEBUG] Iniciando validação detalhada...")
        
        // Validar nome
        let cleanName = FormattingUtils.nameClean(fullName)
        print("🔍 [DEBUG] Nome limpo: '\(cleanName)' (count: \(cleanName.count))")
        if cleanName.isEmpty {
            print("❌ [DEBUG] Nome vazio")
            errorMessage = "Por favor, digite seu nome completo."
            return false
        }
        
        if cleanName.count < 2 {
            print("❌ [DEBUG] Nome muito curto: \(cleanName.count) caracteres")
            errorMessage = "Nome deve ter pelo menos 2 caracteres."
            return false
        }
        print("✅ [DEBUG] Nome válido")
        
        // Validar telefone
        let phoneValid = FormattingUtils.phoneValid(phoneNumber)
        let rawPhone = FormattingUtils.phoneRaw(phoneNumber)
        print("🔍 [DEBUG] Telefone: '\(phoneNumber)' -> raw: '\(rawPhone)' (count: \(rawPhone.count))")
        print("🔍 [DEBUG] Telefone válido: \(phoneValid)")
        if !phoneValid {
            print("❌ [DEBUG] Telefone inválido")
            errorMessage = "Por favor, digite um telefone válido."
            return false
        }
        print("✅ [DEBUG] Telefone válido")
        
        // Validar senha
        print("🔍 [DEBUG] Senha: '\(password.isEmpty ? "vazia" : "preenchida")' (count: \(password.count))")
        if password.isEmpty {
            print("❌ [DEBUG] Senha vazia")
            errorMessage = "Por favor, digite uma senha."
            return false
        }
        
        if password.count < 6 {
            print("❌ [DEBUG] Senha muito curta: \(password.count) caracteres")
            errorMessage = "Senha deve ter pelo menos 6 caracteres."
            return false
        }
        print("✅ [DEBUG] Senha válida")
        
        // Validar confirmação de senha
        print("🔍 [DEBUG] Confirmar senha: '\(confirmPassword.isEmpty ? "vazia" : "preenchida")' (count: \(confirmPassword.count))")
        if confirmPassword.isEmpty {
            print("❌ [DEBUG] Confirmação de senha vazia")
            errorMessage = "Por favor, confirme sua senha."
            return false
        }
        
        if password != confirmPassword {
            print("❌ [DEBUG] Senhas não coincidem")
            errorMessage = "As senhas não coincidem."
            return false
        }
        print("✅ [DEBUG] Confirmação de senha válida")
        
        // Validar CPF (se preenchido)
        let cpfValid = FormattingUtils.cpfValid(cpf)
        print("🔍 [DEBUG] CPF: '\(cpf)' -> válido: \(cpfValid)")
        if !cpf.isEmpty && !cpfValid {
            print("❌ [DEBUG] CPF inválido")
            errorMessage = "Por favor, digite um CPF válido."
            return false
        }
        print("✅ [DEBUG] CPF válido (ou vazio)")
        
        print("✅ [DEBUG] Todas as validações passaram!")
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

