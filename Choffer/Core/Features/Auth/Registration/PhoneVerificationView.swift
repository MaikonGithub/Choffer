import SwiftUI

struct PhoneVerificationView: View {
    // MARK: - State Objects
    @ObservedObject var viewModel: RegistrationViewModel
    
    // MARK: - State
    @State private var verificationCode: String = ""
    @State private var displayPhoneNumber: String = "..."
    
    // MARK: - Properties
    private let isNewUser: Bool
    
    // MARK: - Initialization
    init(viewModel: RegistrationViewModel, isNewUser: Bool = true) {
        self.viewModel = viewModel
        self.isNewUser = isNewUser
    }
    
    var body: some View {
        Group {
            if isNewUser {
                registrationView
            } else {
                loginView
            }
        }
        .onAppear {
            setupViewModel()
        }
        .onChange(of: viewModel.shouldNavigateToPhoneVerification) { _, newValue in
            if newValue {
                // Navegação automática via SessionManager
                viewModel.shouldNavigateToPhoneVerification = false
            }
        }
    }
    
    @ViewBuilder
    private var registrationView: some View {
        VStack(spacing: 16) {
            AnimatedLogo(height: 70)
                .padding(.top, 20)
            
            AnimatedLogo(
                height: 0,
                showText: true,
                text: "VERIFICAÇÃO",
                textSize: 26,
                letterDelay: 0.2
            )
            
            Text("Digite o código enviado para \(displayPhoneNumber)")
                .font(.custom("Avenir-Medium", size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 16) {
                VerificationCodeField(text: $verificationCode)
                
                ResendCodeButton(
                    action: { resendCode() },
                    isLoading: viewModel.isLoading
                )
            }
            
            if let errorMessage = viewModel.errorMessage {
                ErrorMessageView(message: errorMessage)
            }
            
            if let successMessage = viewModel.successMessage {
                SuccessMessageView(message: successMessage)
            }
            
            OnboardingButton(
                title: "Completar Cadastro",
                isLoading: viewModel.isLoading,
                action: { completeRegistration() }
            )
            
            Spacer()
            
            Text("Ferreira Group - Todos os direitos reservados")
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.bottom, 20)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { /* Navegação será gerenciada pelo SwiftUI */ }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Voltar")
                    }
                    .foregroundColor(.primary)
                }
            }
        }
    }
    
    @ViewBuilder
    private var loginView: some View {
        VStack(spacing: 16) {
            AnimatedLogo(height: 70)
                .padding(.top, 20)
            
            AnimatedLogo(
                height: 0,
                showText: true,
                text: "VERIFICAÇÃO",
                textSize: 26,
                letterDelay: 0.2
            )
            
            Text("Digite o código enviado para \(displayPhoneNumber)")
                .font(.custom("Avenir-Medium", size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 16) {
                VerificationCodeField(text: $verificationCode)
                
                ResendCodeButton(
                    action: { resendCode() },
                    isLoading: viewModel.isLoading
                )
            }
            
            if let errorMessage = viewModel.errorMessage {
                ErrorMessageView(message: errorMessage)
            }
            
            if let successMessage = viewModel.successMessage {
                SuccessMessageView(message: successMessage)
            }
            
            OnboardingButton(
                title: "Entrar",
                isLoading: viewModel.isLoading,
                action: { completeRegistration() }
            )
            
            Spacer()
            
            Text("Ferreira Group - Todos os direitos reservados")
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.bottom, 20)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { /* Navegação será gerenciada pelo SwiftUI */ }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Voltar")
                    }
                    .foregroundColor(.primary)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func setupViewModel() {
        // Configurar o telefone para exibição formatado
        displayPhoneNumber = FormattingUtils.phoneDisplay(viewModel.phoneNumber)
    }
    
    private func completeRegistration() {
        viewModel.completeRegistration(verificationCode: verificationCode)
    }
    
    private func resendCode() {
        viewModel.startRegistration()
    }
}

#Preview {
    PhoneVerificationView(
        viewModel: RegistrationViewModel(),
        isNewUser: true
    )
    .padding(.top, 30)
} 