import SwiftUI

struct OnboardingLinkButton: View {
    // MARK: - Properties
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.blue)
                .font(.body)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        OnboardingLinkButton(title: "Fazer Login") {}
        OnboardingLinkButton(title: "Criar conta") {}
    }
    .padding()
} 