import SwiftUI

struct RegistrationView: View {
    // MARK: - State Objects
    @StateObject private var viewModel: RegistrationViewModel
    
    // MARK: - Initialization
    init() {
        self._viewModel = StateObject(wrappedValue: RegistrationViewModel())
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Logo animada
                    AnimatedLogo(height: 80)
                        .padding(.top, 20)
                    
                    // Header
                    VStack(spacing: 8) {
                        AnimatedLogo(
                            height: 0,
                            showText: true,
                            text: "CRIAR CONTA",
                            textSize: 28,
                            letterDelay: 0.2
                        )
                        
                        Text("Preencha seus dados para começar")
                            .font(.custom("Avenir-Medium", size: 16))
                            .foregroundColor(.secondary)
                    }
                    
                    // Campos de entrada
                    VStack(spacing: 16) {
                        OnboardingTextField(
                            placeholder: "Nome Completo",
                            text: $viewModel.fullName,
                            icon: "person",
                            textContentType: .name,
                            maxLength: 100,
                            fieldType: .text
                        )
                        
                        OnboardingTextField(
                            placeholder: "CPF",
                            text: $viewModel.cpf,
                            icon: "creditcard",
                            keyboardType: .numberPad,
                            textContentType: .none,
                            maxLength: 14,
                            formatter: FormattingUtils.cpfDisplay,
                            fieldType: .cpf
                        )
                        
                        OnboardingTextField(
                            placeholder: "Telefone",
                            text: $viewModel.phoneNumber,
                            icon: "phone",
                            keyboardType: .phonePad,
                            textContentType: .telephoneNumber,
                            maxLength: 15,
                            formatter: FormattingUtils.phoneDisplay,
                            fieldType: .phoneNumber
                        )
                        
                        OnboardingTextField(
                            placeholder: "Senha",
                            text: $viewModel.password,
                            icon: "lock",
                            isSecure: true,
                            textContentType: .newPassword,
                            maxLength: 50,
                            fieldType: .password
                        )
                        
                        OnboardingTextField(
                            placeholder: "Confirmar Senha",
                            text: $viewModel.confirmPassword,
                            icon: "lock",
                            isSecure: true,
                            textContentType: .newPassword,
                            maxLength: 50,
                            fieldType: .password
                        )
                    }
                    
                    // Mensagens de estado
                    if let errorMessage = viewModel.errorMessage {
                        ErrorMessageView(message: errorMessage)
                    }
                    
                    if let successMessage = viewModel.successMessage {
                        SuccessMessageView(message: successMessage)
                    }
                    
                    // Botões
                    VStack(spacing: 12) {
                        OnboardingButton(
                            title: "Criar Conta",
                            isLoading: viewModel.isLoading
                        ) {
                            viewModel.startRegistration()
                        }
                    }
                    
                    // Link para login
//                    HStack {
//                        Text("Já tem uma conta?")
//                            .foregroundColor(.secondary)
//                        
//                        NavigationLink("Fazer Login", destination: LoginView())
//                            .foregroundColor(.blue)
//                    }
                    
                    Spacer(minLength: 30)
                    
                    // Copyright
                    Text("Ferreira Group - Todos os direitos reservados")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 24)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Navegação automática via SwiftUI
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Voltar")
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
            .onChange(of: viewModel.shouldNavigateToPhoneVerification) { _, newValue in
                if newValue {
                    // Navegação para tela de verificação SMS
                    // A navegação será feita via NavigationLink ou programaticamente
                }
            }
            .navigationDestination(isPresented: $viewModel.shouldNavigateToPhoneVerification) {
                PhoneVerificationView(viewModel: viewModel, isNewUser: true)
            }

        }
        .onAppear {
            // ViewModel já está configurado corretamente
        }
    }
}

#Preview {
    RegistrationView()
        .padding(.top, 30)
}
