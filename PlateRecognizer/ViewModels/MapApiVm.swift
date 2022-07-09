//
//  MapApiVm.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 06.07.2022.
//

import MapKit

class MapApiVm: ObservableObject {
  private static let kyiv = CLLocationCoordinate2D(
    latitude: 30.53268990945071,
    longitude: 50.40241133943426
  )
  
  @Published var region: MKCoordinateRegion?
  @Published var location: AnnotationLocation?
  @Published var failedDataFetch = false
  
  init(query: String) {
    load(address: query)
  }
  
  private func load(address: String) {
    Task {
      do {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "\(address)"
        searchRequest.region = MKCoordinateRegion(
          center: MapApiVm.kyiv,
          span: MKCoordinateSpan(latitudeDelta: 20000, longitudeDelta: 20000))
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        let result = try await activeSearch.start()
        
        let lat = result.boundingRegion.center.latitude
        let long = result.boundingRegion.center.longitude
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        print("Long = \(long), lat = \(lat)")
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        
        DispatchQueue.main.async {
          self.location = AnnotationLocation(coordinate: coordinate)
          self.region = MKCoordinateRegion(center: coordinate, span: span)
        }
      } catch {
        DispatchQueue.main.async { [weak self] in self?.failedDataFetch = true }
        print("Could not get map coordinates: \(error)")
      }
    }
  }
}

struct AnnotationLocation: Identifiable {
  let id = UUID()
  let coordinate: CLLocationCoordinate2D
}
