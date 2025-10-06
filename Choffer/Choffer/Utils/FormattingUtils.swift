import Foundation

/// Utilitário para formatação de dados
/// Gerencia formatação visual (UI) e backend (Firebase)
struct FormattingUtils {
    
    // MARK: - Phone Formatting
    
    /// Formata telefone para exibição: (11) 99999-9999
    static func phoneDisplay(_ phone: String) -> String {
        let digits = phone.filter { $0.isNumber }
        
        // Formatar A CADA DÍGITO
        switch digits.count {
        case 1...2:
            return digits
        case 3...6:
            let ddd = String(digits.prefix(2))
            let number = String(digits.dropFirst(2))
            return "(\(ddd)) \(number)"
        case 7...10:
            let ddd = String(digits.prefix(2))
            let firstPart = String(digits.dropFirst(2).prefix(4))
            let secondPart = String(digits.dropFirst(6))
            return "(\(ddd)) \(firstPart)-\(secondPart)"
        case 11:
            let ddd = String(digits.prefix(2))
            let firstPart = String(digits.dropFirst(2).prefix(5))
            let secondPart = String(digits.dropFirst(7))
            return "(\(ddd)) \(firstPart)-\(secondPart)"
        default:
            return digits
        }
    }
    
    /// Formata telefone para Firebase (formato E.164): +5511999999999
    static func phoneFirebase(_ phone: String) -> String {
        let digits = phone.filter { $0.isNumber }
        return "+55" + digits
    }
    
    /// Extrai apenas números do telefone: 11999999999
    static func phoneRaw(_ phone: String) -> String {
        return phone.filter { $0.isNumber }
    }
    
    /// Valida se o telefone está no formato correto
    static func phoneValid(_ phone: String) -> Bool {
        let digits = phone.filter { $0.isNumber }
        return digits.count >= 10 && digits.count <= 11
    }
    
    // MARK: - CPF Formatting
    
    /// Formata CPF para exibição: 123.456.789-01
    static func cpfDisplay(_ cpf: String) -> String {
        let digits = cpf.filter { $0.isNumber }
        
        // Formatar A CADA DÍGITO
        switch digits.count {
        case 1...3:
            return digits
        case 4...6:
            let firstPart = String(digits.prefix(3))
            let secondPart = String(digits.dropFirst(3))
            return "\(firstPart).\(secondPart)"
        case 7...9:
            let firstPart = String(digits.prefix(3))
            let secondPart = String(digits.dropFirst(3).prefix(3))
            let thirdPart = String(digits.dropFirst(6))
            return "\(firstPart).\(secondPart).\(thirdPart)"
        case 10...11:
            let firstPart = String(digits.prefix(3))
            let secondPart = String(digits.dropFirst(3).prefix(3))
            let thirdPart = String(digits.dropFirst(6).prefix(3))
            let fourthPart = String(digits.dropFirst(9))
            return "\(firstPart).\(secondPart).\(thirdPart)-\(fourthPart)"
        default:
            return digits
        }
    }
    
    /// Extrai apenas números do CPF: 12345678901
    static func cpfRaw(_ cpf: String) -> String {
        return cpf.filter { $0.isNumber }
    }
    
    /// Valida se o CPF está no formato correto
    static func cpfValid(_ cpf: String) -> Bool {
        let digits = cpf.filter { $0.isNumber }
        return digits.count == 11
    }
    
    // MARK: - Name Formatting
    
    /// Limpa nome removendo espaços extras: João Silva
    static func nameClean(_ name: String) -> String {
        // Apenas remove espaços extras no início e fim, mantém espaços entre palavras
        return name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
} 