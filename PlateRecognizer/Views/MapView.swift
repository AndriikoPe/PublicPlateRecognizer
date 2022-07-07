//
//  MapView.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 06.07.2022.
//

import SwiftUI
import MapKit

struct MapView: View {
  @Binding var isPresented: Bool
  
  @StateObject private var map: MapApiVm
  
  init(query: String, isPresented: Binding<Bool>) {
    _map = StateObject(wrappedValue: MapApiVm(query: query))
    self._isPresented = isPresented
  }
  
  var body: some View {
    if let region = map.region, let annotation = map.location {
      Map(coordinateRegion: .constant(region), annotationItems: [annotation]) {
        MapMarker(coordinate: $0.coordinate, tint: .main)
      }.ignoresSafeArea()
    } else {
      VStack {
        Spacer()
        ProgressView()
          .frame(maxWidth: .infinity)
          .tint(.black)
        Spacer()
      }
      .alert(
        "Could not get map coordinates.",
        isPresented: $map.failedDataFetch
      ) { Button("OK") { isPresented = false } }
    }
  }
}

struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    MapView(query: "ТСЦ 1441", isPresented: .constant(true))
  }
}
