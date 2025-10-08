//import SwiftUI
//
//struct ProfileSelectionView: View {
//    // MARK: - State Objects
//    @StateObject private var viewModel = ProfileSelectionViewModel()
//    
//    var body: some View {
//        GeometryReader { geometry in
//            VStack(spacing: 32) {
//                Text("Selecione seu perfil")
//                    .font(.largeTitle)
//                    .bold()
//                    .padding(.top, 40)
//                
//                // Layout responsivo baseado na orientação
//                if geometry.size.width > geometry.size.height {
//                    // Horizontal - usar HStack
//                    HStack(spacing: 32) {
//                        ProfileSelectionButton(
//                            title: "Passageiro",
//                            description: "Solicite corridas e viaje com conforto",
//                            icon: "person.fill",
//                            color: .blue
//                        ) {
//                            viewModel.selectProfile(.passenger)
//                        }
//                        .frame(maxWidth: .infinity)
//                        
//                        ProfileSelectionButton(
//                            title: "Motorista",
//                            description: "Ofereça corridas e ganhe dinheiro",
//                            icon: "car.fill",
//                            color: .green
//                        ) {
//                            viewModel.selectProfile(.driver)
//                        }
//                        .frame(maxWidth: .infinity)
//                    }
//                    .padding(.horizontal, 24)
//                } else {
//                    // Vertical - usar VStack
//                    VStack(spacing: 16) {
//                        ProfileSelectionButton(
//                            title: "Passageiro",
//                            description: "Solicite corridas e viaje com conforto",
//                            icon: "person.fill",
//                            color: .blue
//                        ) {
//                            viewModel.selectProfile(.passenger)
//                        }
//                        
//                        ProfileSelectionButton(
//                            title: "Motorista",
//                            description: "Ofereça corridas e ganhe dinheiro",
//                            icon: "car.fill",
//                            color: .green
//                        ) {
//                            viewModel.selectProfile(.driver)
//                        }
//                    }
//                    .padding(.horizontal, 24)
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
//                Spacer()
//                
//                // Botão de logout
//                Button(action: {
//                    Task {
//                        await viewModel.signOut()
//                    }
//                }) {
//                    HStack {
//                        Image(systemName: "rectangle.portrait.and.arrow.right")
//                            .font(.caption)
//                        Text("Sair")
//                            .font(.body)
//                    }
//                    .foregroundColor(.red)
//                    .padding(.horizontal, 16)
//                    .padding(.vertical, 8)
//                    .background(Color.red.opacity(0.1))
//                    .cornerRadius(8)
//                }
//                .padding(.bottom, 20)
//            }
//            .padding()
//        }
//    }
//}
//
//#Preview {
//    ProfileSelectionView()
//        .padding(.top, 30)
//}
