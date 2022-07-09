//
//  RecognizedPlateModel.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 09.07.2022.
//

import RealmSwift

final class RecognizedPlateModel: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var id: ObjectId
  
  @Persisted var number: String
  @Persisted var imageData = Data()
  @Persisted var recognizedData = List<RecognizedPlateModelDetails>()
  
  convenience init(number: String, imageData: Data?, recognizedData: PlateData) {
    self.init()
    
    self.number = number
    if let data = imageData { self.imageData = data }
    self.recognizedData.append(objectsIn: recognizedData.operations.map {
      RecognizedPlateModelDetails(operation: $0)
    })
  }
  
  var getPlate: Plate {
    Plate(number)
  }
  
  var getPlateData: PlateData {
    PlateData(operations: recognizedData.map { $0.operationElement })
  }
}

final class RecognizedPlateModelDetails: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var id: ObjectId
  @Persisted var registeredAt = ""
  @Persisted var modelYear = 0
  @Persisted var vendor = ""
  @Persisted var model = ""
  @Persisted var operation = ""
  @Persisted var department = ""
  @Persisted var color = ""
  @Persisted var isRegisteredToCompany = false
  @Persisted var address = ""
  @Persisted var koatuu = 0
  @Persisted var kind = ""
  @Persisted var operationGroup = ""
  
  convenience init(operation: OperationElement) {
    self.init()
    self.registeredAt = operation.registeredAt
    self.modelYear = operation.modelYear
    self.vendor = operation.vendor
    self.model = operation.model
    self.operation = operation.operation.ua
    self.department = operation.department
    self.color = operation.color.ua
    self.isRegisteredToCompany = operation.isRegisteredToCompany
    self.address = operation.address
    self.koatuu = operation.koatuu
    self.kind = operation.kind.ua
    self.operationGroup = operation.operationGroup.ua
  }
  
  var operationElement: OperationElement {
    OperationElement(
      registeredAt: registeredAt,
      modelYear: modelYear,
      vendor: vendor,
      model: model,
      operation: Ua(ua: operation),
      department: department,
      color: Ua(ua: color),
      isRegisteredToCompany: isRegisteredToCompany,
      address: address,
      koatuu: koatuu,
      kind: Ua(ua: kind),
      operationGroup: Ua(ua: operationGroup))
  }
}
