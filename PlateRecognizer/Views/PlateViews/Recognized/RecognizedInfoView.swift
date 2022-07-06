//
//  RecognizedInfoView.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 04.07.2022.
//

import SwiftUI

struct RecognizedInfoView: View {
  let plateDataOperations: [OperationElement]
  @State private var presentedInfo: OperationElement? = nil
  
  var body: some View {
    ScrollView {
      VStack {
        ForEach(plateDataOperations) { operation in
          Button {
            presentedInfo = operation
          } label: {
            HStack {
              Text(operation.vendor)
              Text(verbatim: "\(operation.model), \(operation.modelYear)")
            }
            .font(.title3)
            .padding()
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
          }
          .overlay {
            RoundedRectangle(cornerRadius: 7)
              .stroke(lineWidth: 2)
              .foregroundColor(.main)
          }
        }
      }
      .sheet(item: $presentedInfo) { info in
        NavigationView {
          RecognizedDetails(details: info)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 16)
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Деталі")
            .toolbar {
              Button("Готово") { withAnimation { presentedInfo = nil } }
              .foregroundColor(.white)
            }
        }
      }
    }
  }
}

struct RecognizedInfoView_Previews: PreviewProvider {
  static var previews: some View {
    RecognizedInfoView(plateDataOperations: [
      OperationElement(
        registeredAt: "14.06.2019",
        modelYear: 2013,
        vendor: "Toyota",
        model: "PRIUS",
        operation: Ua(ua:"Перереєстрація тз на нов. власн. по договору укладеному в тсц"),
        department: "ТСЦ 1441",
        color: Ua(ua: "Білий"),
        isRegisteredToCompany: false,
        address: "Донецька область/м.Донецьк, Маріуполь, Центральний",
        koatuu: 1412336300,
        kind: Ua(ua: "Легковий"),
        operationGroup: Ua(ua: "Вторинна реєстрація")),
      OperationElement(
        registeredAt: "27.02.2021",
        modelYear: 2015,
        vendor: "Nissan",
        model: "LEAF",
        operation: Ua(ua: "Перереєстрація при заміні номерного знаку"),
        department: "ТСЦ 1441",
        color: Ua(ua: "Білий"),
        isRegisteredToCompany: false,
        address: "Донецька область/м.Донецьк, Маріуполь, Центральний",
        koatuu: 1412336300,
        kind: Ua(ua: "Легковий"),
        operationGroup: Ua(ua: "Вторинна реєстрація")),
      OperationElement(
        registeredAt: "24.05.2013",
        modelYear: 2010,
        vendor: "Volkswagen",
        model: "PASSAT 1.8",
        operation: Ua(ua: "Перереєстрація при заміні номерного знаку"),
        department: "ТСЦ 1441",
        color: Ua(ua: "Білий"),
        isRegisteredToCompany: false,
        address: "Донецька область/м.Донецьк, Маріуполь, Центральний",
        koatuu: 1412336300,
        kind: Ua(ua: "Легковий"),
        operationGroup: Ua(ua: "Вторинна реєстрація")),
      OperationElement(
        registeredAt: "17.02.2018",
        modelYear: 2001,
        vendor: "Nissan",
        model: "MAXIMA",
        operation: Ua(ua: "Перереєстрація при заміні номерного знаку"),
        department: "ТСЦ 1441",
        color: Ua(ua: "Білий"),
        isRegisteredToCompany: false,
        address: "Донецька область/м.Донецьк, Маріуполь, Центральний",
        koatuu: 1412336300,
        kind: Ua(ua: "Легковий"),
        operationGroup: Ua(ua: "Вторинна реєстрація"))
    ])
  }
}
