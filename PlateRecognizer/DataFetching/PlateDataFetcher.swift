//
//  Recognizer.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 30.06.2022.
//

import Foundation

final class PlateDataFetcher {
  private let baseUrl = "https://baza-gai.com.ua/nomer/"
  private let apiKey = "4313f183aab125bdc886d8affc272842"
  
  func fetchData(for number: String) async -> PlateData? {
    guard let url = URL(string: "\(baseUrl)\(number)") else { return nil }
    print("Fetching for url: \(url)")
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let plateData = try JSONDecoder().decode(PlateData.self, from: data)
      return plateData
    } catch {
      print(error)
    }
    return nil
  }
  
  static let shared = PlateDataFetcher()
  
  private init() {}
}
