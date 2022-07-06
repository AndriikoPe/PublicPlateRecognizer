//
//  PlateListView.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 23.06.2022.
//

import SwiftUI

struct PlateListView: View {
  @EnvironmentObject var platesVm: PlatesVm
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      LazyVStack(spacing: 0) {
        ForEach(platesVm.savedPlates) { plate in
          NavigationLink {
            PlateDetailsView(presenting: .constant(true))
          } label: {
            row(for: plate)
          }
          .frame(height: 128)
        }
      }
    }
  }
  
  private func row(for plate: Plate) -> some View {
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
      .environmentObject(PlatesVm.defaultVm)
  }
}
