//import SwiftUI
//
///// View responsável pela tela de login do usuário
///// Segue o padrão MVVM com separação clara de responsabilidades
//struct LoginView: View {
//    
//    // MARK: - State Objects
//    
//    @StateObject private var viewModel = LoginViewModel()
//    
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 16) {
//                // Logo animada com texto
//                AnimatedLogo(
//                    height: 100,
//                    showText: true,
//                    text: "CHOFFER",
//                    textSize: 32,
//                    letterDelay: 0.3
//                )
//                .padding(.top, 40)
//                
//                VStack(spacing: 16) {
//                    OnboardingTextField(
//                        placeholder: "Telefone",
//                        text: $viewModel.phoneNumber,
//                        icon: "phone",
//                        keyboardType: .phonePad,
//                        textContentType: .telephoneNumber,
//                        maxLength: 15,
//                        formatter: FormattingUtils.formatPhoneForDisplay,
//                        fieldType: .phoneNumber
//                    )
//                    OnboardingTextField(
//                        placeholder: "Senha",
//                        text: $viewModel.password,
//                        icon: "lock",
//                        isSecure: true,
//                        maxLength: 50
//                    )
//                }
//                
//                if let errorMessage = viewModel.errorMessage {
//                    ErrorMessageView(message: errorMessage)
//                }
//                
//                if let successMessage = viewModel.successMessage {
//                    SuccessMessageView(message: successMessage)
//                }
//                
//                OnboardingButton(title: "Entrar", isLoading: viewModel.isLoading, action: viewModel.login)
//                
//                HStack {
//                    Text("Não tem uma conta?")
//                    NavigationLink("Criar conta", destination: RegistrationView())
//                        .foregroundColor(.blue)
//                }
//                
//                Spacer()
//                
//            }
//            .onChange(of: viewModel.shouldNavigateToPhoneVerification) { _, newValue in
//                if newValue {
//                    // Navegação automática via SessionManager
//                    viewModel.shouldNavigateToPhoneVerification = false
//                }
//            }
//            .padding()
//        }
//    }
//    
//
//}
//
//#Preview {
//    LoginView()
//        .padding(.top, 30) // Simula o espaço da navigation bar
//} 
