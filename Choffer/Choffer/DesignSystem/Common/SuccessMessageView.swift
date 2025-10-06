import SwiftUI

struct SuccessMessageView: View {
    // MARK: - Properties
    let message: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.caption)
            
            Text(message)
                .foregroundColor(.green)
                .font(.caption)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    VStack(spacing: 16) {
        SuccessMessageView(message: "Conta criada com sucesso!")
        SuccessMessageView(message: "Login realizado com sucesso. Redirecionando...")
        SuccessMessageView(message: "Código enviado para seu telefone")
    }
    .padding()
} 