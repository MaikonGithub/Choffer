import SwiftUI

struct OnboardingTextField: View {
    // MARK: - Properties
    let placeholder: String
    @Binding var text: String
    var icon: String? = nil
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var maxLength: Int? = nil
    var formatter: ((String) -> String)? = nil
    var fieldType: FieldType = .text
    var isValid: Bool = true
    var showValidation: Bool = false
    
    // MARK: - State
    @State private var displayText: String = ""
    
    // MARK: - Enums
    enum FieldType {
        case text           // Nome, email, etc.
        case phoneNumber    // Telefone
        case cpf           // CPF
        case password      // Senha
        case number        // Apenas números
    }
    
    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.gray)
            }
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textContentType(textContentType)
                    .onChange(of: text) { _, newValue in
                        applyLimitsAndFormatting(to: newValue)
                    }
            } else {
                TextField(placeholder, text: $displayText)
                    .keyboardType(keyboardType)
                    .textContentType(textContentType)
                    .onChange(of: displayText) { _, newValue in
                        applyLimitsAndFormatting(to: newValue)
                    }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .onAppear {
            // Inicializar displayText com formatação se disponível
            if let formatter = formatter {
                displayText = formatter(text)
            } else {
                displayText = text
            }
        }
    }
    
    private func applyLimitsAndFormatting(to newValue: String) {
        var processedValue = newValue
        
        // Tratamento específico por tipo de campo
        switch fieldType {
        case .text:
            processedValue = newValue
            
        case .phoneNumber:
            let digits = newValue.filter { $0.isNumber }
            let limitedDigits = String(digits.prefix(11))
            processedValue = formatter?(limitedDigits) ?? limitedDigits
            
        case .cpf:
            let digits = newValue.filter { $0.isNumber }
            let limitedDigits = String(digits.prefix(11))
            processedValue = formatter?(limitedDigits) ?? limitedDigits
            
        case .password:
            processedValue = newValue
            
        case .number:
            processedValue = newValue.filter { $0.isNumber }
        }
        
        // Aplicar limite de caracteres
        if let maxLength = maxLength, fieldType == .text || fieldType == .password || fieldType == .number {
            processedValue = String(processedValue.prefix(maxLength))
        }
        
        // Atualizar display visual
        if displayText != processedValue {
            displayText = processedValue
        }
        
        // Atualizar binding para backend
        switch fieldType {
        case .phoneNumber, .cpf:
            let digitsOnly = newValue.filter { $0.isNumber }
            let limitedDigitsOnly = String(digitsOnly.prefix(11))
            if text != limitedDigitsOnly {
                text = limitedDigitsOnly
            }
        case .text:
            if text != newValue {
                text = newValue
            }
        default:
            if text != newValue {
                text = newValue
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        OnboardingTextField(
            placeholder: "Nome",
            text: .constant("João Silva"),
            icon: "person",
            fieldType: .text
        )
        OnboardingTextField(
            placeholder: "Telefone",
            text: .constant("11999999999"),
            icon: "phone",
            keyboardType: .phonePad,
            textContentType: .telephoneNumber,
            fieldType: .phoneNumber
        )
        OnboardingTextField(
            placeholder: "CPF",
            text: .constant("12345678901"),
            icon: "creditcard",
            keyboardType: .numberPad,
            fieldType: .cpf
        )
        OnboardingTextField(
            placeholder: "Senha", 
            text: .constant("senha123"), 
            icon: "lock",
            isSecure: true,
            fieldType: .password
        )
    }
    .padding()
    .padding(.top, 30) // Simula o espaço da navigation bar
} 
