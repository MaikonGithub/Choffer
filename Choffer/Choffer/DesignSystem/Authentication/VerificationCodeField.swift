import SwiftUI

struct VerificationCodeField: View {
    // MARK: - Properties
    @Binding var text: String
    var maxLength: Int = 6
    
    var body: some View {
        HStack {
            Image(systemName: "key")
                .foregroundColor(.gray)
            TextField("Código de verificação", text: $text)
                .keyboardType(.numberPad)
                .onChange(of: text) { _, newValue in
                    // Limitar o número de caracteres e manter apenas números
                    let filtered = newValue.filter { $0.isNumber }
                    let limited = String(filtered.prefix(maxLength))
                    if limited != newValue {
                        text = limited
                    }
                }
                .onAppear {
                    // Garantir que o campo esteja limpo ao aparecer
                    if text.count > maxLength {
                        text = String(text.prefix(maxLength))
                    }
                }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

#Preview {
    VerificationCodeField(text: .constant(""))
        .padding()
} 