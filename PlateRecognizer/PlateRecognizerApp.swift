//
//  PlateRecognizerApp.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 19.06.2022.
//

import SwiftUI

@main
struct PlateRecognizerApp: App {
  @ObservedObject var platesVm = PlatesVm.defaultVm
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(platesVm)
        .statusBar(hidden: true)
        .onAppear {
          UINavigationBar.appearance().backgroundColor = UIColor(named: "main")
          UINavigationBar.appearance().barTintColor = .white
          UINavigationBar.appearance().tintColor = .white
          guard let font = UIFont(name: "Roboto", size: 24) else { return }
          UINavigationBar.appearance().titleTextAttributes = [
            .font: font,
            .foregroundColor: UIColor.white
          ]
        }
    }
  }
}
