// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation
import CoreText

struct PlateData: Codable {
  let vin: String?
  let region: Region
  let vendor, model: String
  let modelYear: Int
  let photoURL: String
  let isStolen: Bool
  let stolenDetails: [StolenDetail]?
  let operations: [OperationElement]
  
  var configuredUrl: URL? {
    URL(string: photoURL.replacingOccurrences(of: " ", with: "%20"))
  }
  
  enum CodingKeys: String, CodingKey {
    case vin, region, vendor, model
    case modelYear = "model_year"
    case photoURL = "photo_url"
    case isStolen = "is_stolen"
    case stolenDetails = "stolen_details"
    case operations
  }
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

// MARK: - StolenDetail
struct StolenDetail: Codable {
  let theftAt, vendorTitle: String
  let color: Ua
  let rawColor, carType, chassisNumber, bodyNumber: String
  let departmentTitle: String
  
  enum CodingKeys: String, CodingKey {
    case theftAt = "theft_at"
    case vendorTitle = "vendor_title"
    case color
    case rawColor = "raw_color"
    case carType = "car_type"
    case chassisNumber = "chassis_number"
    case bodyNumber = "body_number"
    case departmentTitle = "department_title"
  }
}
