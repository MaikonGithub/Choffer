import SwiftUI

struct ErrorMessageView: View {
    // MARK: - Properties
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.red)
            .font(.caption)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    VStack(spacing: 16) {
        ErrorMessageView(message: "Este é um erro de exemplo")
        ErrorMessageView(message: "Outro erro com texto mais longo para testar o alinhamento")
    }
    .padding()
} 