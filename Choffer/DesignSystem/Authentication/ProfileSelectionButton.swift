import SwiftUI

struct ProfileSelectionButton: View {
    // MARK: - Properties
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 40, height: 40)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding()
            .frame(minHeight: 80)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 16) {
        ProfileSelectionButton(
            title: "Passageiro",
            description: "Solicite corridas e viaje com conforto",
            icon: "person.fill",
            color: .blue
        ) {}
        
        ProfileSelectionButton(
            title: "Motorista",
            description: "Ofereça corridas e ganhe dinheiro",
            icon: "car.fill",
            color: .green
        ) {}
    }
    .padding()
} 
