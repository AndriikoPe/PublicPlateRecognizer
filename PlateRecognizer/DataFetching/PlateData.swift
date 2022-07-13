// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct PlateData: Codable {
  let operations: [OperationElement]
}

// MARK: - OperationElement
struct OperationElement: Codable, Identifiable {
  let id = UUID()
  let registeredAt: String
  let modelYear: Int
  let vendor, model: String
  let operation: Ua
  let department: String
  let color: Ua
  let isRegisteredToCompany: Bool
  let address: String
  let koatuu: Int
  let kind, operationGroup: Ua
  
  enum CodingKeys: String, CodingKey {
    case registeredAt = "registered_at"
    case modelYear = "model_year"
    case vendor
    case model, operation, department, color
    case isRegisteredToCompany = "is_registered_to_company"
    case address, koatuu, kind
    case operationGroup = "operation_group"
  }
}

// MARK: - OperationOperation
struct Ua: Codable {
  let ua: String
}

// MARK: - Region
struct Region: Codable {
  let nameUa: String
  
  enum CodingKeys: String, CodingKey {
    case nameUa = "name_ua"
  }
}
