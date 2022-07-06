//
//  MapApiVm.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 06.07.2022.
//

import MapKit

class MapApiVm: ObservableObject {
  private let baseUrl = "http://api.positionstack.com/v1/forward"
  private let apiKey = "350ccfcf72d1f5b66b5aa80cb55e06c0"
  
  @Published var region: MKCoordinateRegion?
  @Published var location: AnnotationLocation?
  @Published var failedDataFetch = false
  
  init(query: String) {
    loadLocation(query, delta: 0.5)
  }
  
  private func loadLocation(_ address: String, delta: Double) {
    guard let stringUrl = "\(baseUrl)?access_key=\(apiKey)&query=\(address)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: stringUrl)
    else { return }
    print("Requesting url: \(url)")
    Task {
      do {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let coordinates = try JSONDecoder().decode(Address.self, from: data)
        guard let details = coordinates.data.first else {
          print("Got empty map data")
          DispatchQueue.main.async { [weak self] in
            self?.failedDataFetch = true
          }
          return
        }
        DispatchQueue.main.async { [weak self] in
          let lat = details.latitude
          let long = details.longitude
          let name = details.name
          
          let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
          self?.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: lat, longitude: long),
            span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
          )
          
          self?.location = AnnotationLocation(name: name ?? "", coordinate: center)
        }
        
      } catch {
        print("Could not get address on map: \(error)")
        failedDataFetch = true
      }
    }
  }
}
  