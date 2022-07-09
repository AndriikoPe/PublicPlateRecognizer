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
  @Environment(\.realm) var realm
  // MLKit failed to recognized text.
  @Published var recognitionFailed = false
  
  // Could not get data for recognized number.
  @Published var couldNotGetData = false
  
  @Published var recognizedPlateText: Plate? = nil
  @Published var image: UIImage? = nil
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
  
  func delete(number: String, replacing model: RecognizedPlateModel? = nil) {
    if let savedValue = realm.objects(RecognizedPlateModel.self)
        .filter("number = %@", number).first,
       savedValue != model {
      let savedValueOperations = savedValue.recognizedData
      try? realm.write {
        realm.delete(savedValueOperations)
        realm.delete(savedValue)
      }
    }
  }
  
  private func get(_ result: MLKitText, _ image: UIImage) {
    self.image = image
    guard let plateTextLine = plateTextLine(from: result) else {
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
        guard let self = self else { return }
        self.plateData = plateData
        self.save(number: plate.number, data: plateData)
      }
    }
    
    self.recognizedPlateText = plate
  }
  
  private func save(number: String, data plateData: PlateData) {
    let model = RecognizedPlateModel(
      number: number,
      imageData: self.image?.jpegData(compressionQuality: 1),
      recognizedData: plateData
    )
    delete(number: number, replacing: model)
    
    try? realm.write {
      realm.add(model)
    }
  }
  
  private func plateTextLine(from mlKitText: MLKitText) -> String? {
    mlKitText.blocks.compactMap({ block in
      block.lines.compactMap { line in
        print("recognizing \(line.text)")
        guard let possiblePlates = line.text.replacingOccurrences(of: " ", with: "").subranges(of: 8)
        else { return nil }
        print("Possible plates: \(possiblePlates)")
        
        return possiblePlates.first { Plate.isPlate(value: $0) }
      }.first
    }).first
  }
}
