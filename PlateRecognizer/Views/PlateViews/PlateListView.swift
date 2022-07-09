//
//  PlateListView.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 23.06.2022.
//

import SwiftUI
import RealmSwift

struct PlateListView: View {
  @Environment(\.realm) var realm
  @ObservedResults(RecognizedPlateModel.self) var plates
  @State var searchText = ""
  
  private func image(_ data: Data) -> Image? {
    guard let uiImage = UIImage(data: data) else { return nil }
    return Image(uiImage: uiImage)
  }
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      LazyVStack(spacing: 0) {
        ForEach(plates) { plate in
          NavigationLink {
            PlateDetailsView(
              image: image(plate.imageData),
              plateData: plate.getPlateData,
              recognizedPlateText: plate.getPlate
            )
          } label: {
            row(for: plate)
          }
          .frame(height: 128)
        }
      }
    }
  }
  
  private func row(for plate: RecognizedPlateModel) -> some View {
    ZStack {
      Color.white.frame(height: 120)
        .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 2)
      PlateView(text: plate.number)
        .foregroundColor(.black)
    }
  }
}

struct PlateListView_Previews: PreviewProvider {
  static var previews: some View {
    PlateListView()
  }
}
