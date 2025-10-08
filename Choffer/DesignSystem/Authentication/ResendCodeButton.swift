import SwiftUI

struct ResendCodeButton: View {
    // MARK: - Properties
    let action: () -> Void
    var isLoading: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                }
                Text("Reenviar código")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .disabled(isLoading)
    }
}

#Preview {
    VStack(spacing: 16) {
        ResendCodeButton(action: {})
        ResendCodeButton(action: {}, isLoading: true)
    }
    .padding()
} 