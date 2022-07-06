//
//  MapModel.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 06.07.2022.
//

import MapKit

struct Address: Codable {
  let data: [Datum]
}

struct Datum: Codable {
  let latitude, longitude: Double
  let name: String?
}

struct AnnotationLocation: Identifiable {
  let id = UUID()
  let name: String
  let coordinate: CLLocationCoordinate2D
}

