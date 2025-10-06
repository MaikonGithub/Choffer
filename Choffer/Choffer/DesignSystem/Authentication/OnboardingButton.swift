import SwiftUI

struct OnboardingButton: View {
    // MARK: - Properties
    let title: String
    var color: Color = .blue
    var isLoading: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                Text(title)
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(8)
            .opacity(isLoading ? 0.7 : 1)
        }
        .disabled(isLoading)
    }
}

#Preview {
    VStack(spacing: 16) {
        OnboardingButton(title: "Entrar", color: .black, isLoading: false) {}
        OnboardingButton(title: "Carregando...", isLoading: true) {}
    }
    .padding()
} 
