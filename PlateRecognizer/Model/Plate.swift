//
//  Plate.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 24.06.2022.
//

import Foundation

struct Plate: Identifiable, Codable {
  let noSpacesNumber: String
  private(set) var number: String
  let id: UUID
  
  init(_ number: String) {
    self.noSpacesNumber = number.replacingOccurrences(of: " ", with: "")
    self.number = noSpacesNumber
    self.number.insert(" ", at: number.index(number.startIndex, offsetBy: 6))
    self.number.insert(" ", at: number.index(number.startIndex, offsetBy: 2))
    self.id = UUID()
  }
  
  private static let regex = "^[A-Z]{2}[0-9]{4}[A-Z]{2}$"
  
  static func isPlate(value: String) -> Bool {
    value.range(of: regex, options: .regularExpression) != nil
  }
}
