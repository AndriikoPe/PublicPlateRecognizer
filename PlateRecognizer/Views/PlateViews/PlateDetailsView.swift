//
//  PlateDetailsView.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 25.06.2022.
//

import SwiftUI
import MLKitTextRecognition

struct PlateDetailsView: View {
  @EnvironmentObject private var platesVm: PlatesVm
  let image: Image?
  let plateData: PlateData?
  let recognizedPlateText: Plate?
  @State var shouldPresentDeletionAlert = false
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    VStack(spacing: 0) {
      image?.resizable().scaledToFit()
      if let plate = recognizedPlateText {
        recognizedContent(plate)
      }
    }
    .alert(
      "Could not get plate information. Please try again",
      isPresented: $platesVm.recognitionFailed
    ) {
      Button("OK") { presentationMode.wrappedValue.dismiss() }
    }
    .background(.white)
  }
  
  @ViewBuilder
  private func recognizedContent(_ plate: Plate) -> some View {
    PlateView(text: plate.number)
      .foregroundColor(.black)
    if let plateData = plateData {
      RecognizedInfoView(plateDataOperations: plateData.operations)
        .padding(.horizontal)
    } else if platesVm.couldNotGetData {
      Text("Не змогли знайти даних для цього номеру в базі даних")
        .foregroundColor(.black)
    } else {
      ProgressView()
        .frame(width: 100, height: 100)
        .padding()
        .tint(.black.opacity(0.8))
    }
    
    Spacer()
    Button {
      shouldPresentDeletionAlert = true
    } label: {
      ZStack {
        Capsule(style: .circular)
          .foregroundColor(.red)
        Text("Видалити")
          .foregroundColor(.white)
      }
      .alert("Видалити цей номер?", isPresented: $shouldPresentDeletionAlert) {
        Button("Так") {
          if let number = recognizedPlateText?.number {
            print("deleting.")
            platesVm.delete(number: number)
            presentationMode.wrappedValue.dismiss()
          }
        }
        Button("Ні", role: .cancel) { shouldPresentDeletionAlert = false }
      }
    }
    .frame(width: 175, height: 55)
    Spacer()
  }
}
