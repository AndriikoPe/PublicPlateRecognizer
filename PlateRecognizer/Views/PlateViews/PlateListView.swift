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
  
  private var searchResultPlates: Results<RecognizedPlateModel> {
    searchText.isEmpty ? plates : plates.where {
      $0.number.contains(searchText.replacingOccurrences(of: " ", with: "").uppercased())
    }
  }
  
  @State var searchText = ""
  
  private func image(_ data: Data) -> Image? {
    guard let uiImage = UIImage(data: data) else { return nil }
    return Image(uiImage: uiImage)
  }
  
  var body: some View {
    ZStack {
      Color.white
      VStack {
        searchBar
        if searchResultPlates.isEmpty {
          Spacer()
          Text("Нічого немає")
            .foregroundColor(.black)
          Spacer()
        } else {
          list
        }
      }
    }
  }
  
  private var list: some View {
    ScrollView(showsIndicators: false) {
      LazyVStack(spacing: 0) {
        ForEach(searchResultPlates) { plate in
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
  
  private var searchBar: some View {
    ZStack {
      Color.searchBackground
      HStack {
        Image(systemName: "magnifyingglass")
          .padding(.leading, 13)
        TextField("", text: $searchText)
          .placeholder(when: searchText.isEmpty) {
            Text("Search...").foregroundColor(.gray)
          }
      }
    }
    .foregroundColor(.gray)
    .frame(height: 40)
    .overlay {
      RoundedRectangle(cornerRadius: 13)
        .stroke(.gray, lineWidth: 1)
    }
    .padding()
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
