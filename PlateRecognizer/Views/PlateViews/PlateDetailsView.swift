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
  @Binding var presenting: Bool
  
  var body: some View {
    VStack {
      platesVm.image?.resizable().scaledToFit()
      if let plate = platesVm.recognizedPlateText {
        recognizedContent(plate)
      }
    }
    .alert(
      "Could not get plate information. Please try again",
      isPresented: $platesVm.recognitionFailed
    ) {
      Button("OK") { presenting = false }
    }
    .background(.white)
  }
  
  @ViewBuilder
  private func recognizedContent(_ plate: Plate) -> some View {
    PlateView(text: plate.number)
      .foregroundColor(.black)
    if let plateData = platesVm.plateData {
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

    } label: {
      ZStack {
        Capsule(style: .circular)
          .foregroundColor(.red)
        Text("Видалити")
          .foregroundColor(.white)
      }
    }
    .frame(width: 175, height: 55)
    Spacer()
  }
}
