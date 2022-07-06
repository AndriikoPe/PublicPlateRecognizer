//
//  RecognizedDetails.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 04.07.2022.
//

import SwiftUI
import UniformTypeIdentifiers

struct RecognizedDetails: View {
  let details: OperationElement
  @State private var shouldPresentMap = false
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Text("\(details.vendor) \(details.model)")
          .font(.title3)
          .padding(.vertical, 10)
        Group {
          Divider()
          Text(details.operation.ua)
          Divider()
          column("Дата останньої операції МВС", details.registeredAt)
          Divider()
          column("Місце останньої операції МВС", mapValue: details.department)
          Divider()
          column("Адреса", "\(details.address)")
          Divider()
          column("Рік випуску", "\(details.modelYear)")
        }
        Group {
          Divider()
          column("Колір", "\(details.color.ua)")
          Divider()
          column("Тип авто", "\(details.kind.ua)")
          Divider()
          column("Юридична особа", "\(details.isRegisteredToCompany ? "Так" : "Ні")")
          Divider()
          column("КОАТУУ", copyableValue: "\(details.koatuu)")
        }
      }
      .font(.body)
      .foregroundColor(.black)
    }
  }
}

// MARK: - Functions.

extension RecognizedDetails {
  private func column(_ title: String, _ value: String) -> some View {
    HStack(spacing: 0) {
      Text(title)
      Spacer()
      Text(value)
        .frame(minWidth: 100)
    }
    .padding(.vertical, 10)
  }
  
  private func column(_ title: String, mapValue: String) -> some View {
    column(title, value: mapValue, iconName: "mappin.and.ellipse") {
      shouldPresentMap = true
    }
    .sheet(isPresented: $shouldPresentMap) {
      NavigationView {
        MapView(query: mapValue)
          .background(.white)
          .navigationTitle("Мапа")
          .navigationBarTitleDisplayMode(.inline)
          .toolbar {
            Button("Готово") { shouldPresentMap = false }
            .foregroundColor(.white)
          }
      }
    }
  }
  
  private func column(_ title: String, copyableValue: String) -> some View {
    column(title, value: copyableValue, iconName: "square.on.square") {
      UIPasteboard.general.setValue(
        copyableValue,
        forPasteboardType: UTType.plainText.identifier
      )
    }
  }
  
  private func column(
    _ title: String,
    value: String,
    iconName: String,
    action: @escaping () -> ()
  ) -> some View {
    HStack(spacing: 0) {
      Text(title)
      Spacer()
      Button {
        action()
      } label: {
        HStack(spacing: 0) {
          Text(value)
          Image(systemName: iconName)
        }
      }
      .foregroundColor(.black)
    }
    .padding(.vertical, 10)
  }
}

// MARK: - Preview.

struct RecognizedDetails_Previews: PreviewProvider {
  static var previews: some View {
    RecognizedDetails(details: OperationElement(
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
      operationGroup: Ua(ua: "Вторинна реєстрація"))
    )
      .padding(.horizontal, 10)
  }
}
