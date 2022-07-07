//
//  PlatesVm.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 24.06.2022.
//

import SwiftUI
import MLKitVision
import MLKitTextRecognition

typealias MLKitText = MLKitTextRecognition.Text

final class PlatesVm: ObservableObject {
  // MLKit failed to recognized text.
  @Published var recognitionFailed = false
  
  // Could not get data for recognized number.
  @Published var couldNotGetData = false
  
  @Published var recognizedPlateText: Plate? = nil
  @Published var image: Image? = nil
  @Published var plateData: PlateData? = nil
  
  var savedPlates = [Plate]()
  
  static let defaultVm: PlatesVm = {
    let vm = PlatesVm()
    vm.savedPlates = (0...3).map { _ in
      Plate("AA 0055 BP")
    }
    return vm
  }()
  
  private let textRecognizer = TextRecognizer.textRecognizer()
  
  func clearOldData() {
    plateData = nil
    image = nil
    recognizedPlateText = nil
    recognitionFailed = false
    couldNotGetData = false
  }
  
  func tryToRecognizeText(in image: UIImage) {
    let visionImage = VisionImage(image: image)
    visionImage.orientation = image.imageOrientation
    
    textRecognizer.process(visionImage) { [weak self] result, error in
      guard error == nil, let result = result else {
        print("Error precessing image: \(error!)")
        self?.recognitionFailed = true
        return
      }
      self?.get(result, image)
    }
  }
  
  private func get(_ result: MLKitText, _ image: UIImage) {
    self.image = Image(uiImage: image)
    guard let plateTextLine = result.blocks.compactMap({ block in
      block.lines.compactMap { line -> String? in
        print("recognizing \(line.text)")
        guard let possiblePlates = line.text.replacingOccurrences(of: " ", with: "").subranges(of: 8)
        else { return nil }
        print("Possible plates: \(possiblePlates)")
        
        return possiblePlates.first { [weak self] possiblePlate in
          guard let formatted = self?.format(possiblePlate) else { return false }
          return Plate.isPlate(value: formatted)
        }
      }.first
    }).first else {
      recognitionFailed = true
      return
    }
    
    let plate = Plate(plateTextLine)
    Task {
      guard let plateData = await PlateDataFetcher.shared.fetchData(for: plate.noSpacesNumber)
      else {
        print("Could not fetch data for number: \(plate.noSpacesNumber)")
        DispatchQueue.main.async { [weak self] in
          self?.couldNotGetData = true
        }
        return
      }
      DispatchQueue.main.async { [weak self] in
        self?.plateData = plateData
      }
    }
    
    self.recognizedPlateText = plate
  }
  
  private func format(_ value: String) -> String? {
    guard value.count == 8 else { return nil }
    
    let prefixLettersRange = value.startIndex..<value.index(value.startIndex, offsetBy: 2)
    let digitsRange = value.index(value.startIndex, offsetBy: 2)..<value.index(value.endIndex, offsetBy: -2)
    let postfixLettersRange = value.index(value.endIndex, offsetBy: -2)..<value.endIndex
    return value
      .replacingOccurrences(of: "0", with: "O", options: .literal, range: prefixLettersRange)
      .replacingOccurrences(of: "O", with: "0", options: .literal, range: digitsRange)
      .replacingOccurrences(of: "0", with: "O", options: .literal, range: postfixLettersRange)
  }
}
