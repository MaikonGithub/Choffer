import Foundation
import FirebaseFirestore

/// Modelo de dados do usuário para o aplicativo Choffer
/// Representa um usuário cadastrado no sistema
struct User: Codable, Identifiable {
    
    // MARK: - Properties
    
    /// ID único do usuário (mesmo ID do Firebase Auth)
    let id: String
    
    /// Número de telefone do usuário (formato E.164: +5511999999999)
    let phoneNumber: String
    
    /// Nome completo do usuário
    let fullName: String
    
    /// CPF do usuário (opcional)
    let cpf: String?
    
    /// Data de criação da conta
    let createdAt: Timestamp
    
    /// Data da última atualização
    let updatedAt: Timestamp
    
    // MARK: - Initializers
    
    /// Inicializador completo
    init(id: String, phoneNumber: String, fullName: String, cpf: String? = nil, createdAt: Timestamp = Timestamp(), updatedAt: Timestamp = Timestamp()) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.fullName = fullName
        self.cpf = cpf
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    /// Inicializador para novo usuário (com timestamps automáticos)
    init(uid: String, phoneNumber: String, fullName: String, cpf: String? = nil) {
        let now = Timestamp()
        self.id = uid
        self.phoneNumber = phoneNumber
        self.fullName = fullName
        self.cpf = cpf
        self.createdAt = now
        self.updatedAt = now
    }
    
    // MARK: - Firestore Helpers
    /// Converte o usuário para formato do Firestore
    var firestoreData: [String: Any] {
        var data: [String: Any] = [
            "uid": id,
            "phoneNumber": phoneNumber,
            "fullName": fullName,
            "createdAt": createdAt,
            "updatedAt": updatedAt
        ]
        if let cpf = cpf {
            data["cpf"] = cpf
        }
        return data
    }
    
    /// Cria um usuário a partir dos dados do Firestore
    static func fromFirestore(data: [String: Any]) -> User? {
        guard let uid = data["uid"] as? String,
              let phoneNumber = data["phoneNumber"] as? String,
              let fullName = data["fullName"] as? String,
              let createdAt = data["createdAt"] as? Timestamp,
              let updatedAt = data["updatedAt"] as? Timestamp else {
            return nil
        }
        
        let cpf = data["cpf"] as? String
        
        return User(
            id: uid,
            phoneNumber: phoneNumber,
            fullName: fullName,
            cpf: cpf,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
