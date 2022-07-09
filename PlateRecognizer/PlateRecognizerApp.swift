//
//  PlateRecognizerApp.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 19.06.2022.
//

import SwiftUI

@main
struct PlateRecognizerApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @ObservedObject var platesVm = PlatesVm.defaultVm
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(platesVm)
        .statusBar(hidden: true)
    }
  }
}


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
      let navAppearance = UINavigationBarAppearance()
      navAppearance.titleTextAttributes = [
        .font: UIFont(name: "Roboto", size: 24)!,
        .foregroundColor: UIColor.white
      ]
      navAppearance.configureWithTransparentBackground()
      navAppearance.backgroundColor = UIColor(named: "main")

      let barButtonAppearance = UIBarButtonItemAppearance(style: .plain)
      barButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
      navAppearance.buttonAppearance = barButtonAppearance
      
      UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
      UINavigationBar.appearance().compactScrollEdgeAppearance = navAppearance
      UINavigationBar.appearance().standardAppearance = navAppearance
      UINavigationBar.appearance().compactAppearance = navAppearance
      UINavigationBar.appearance().tintColor = .white

      UITextField.appearance().tintColor = .lightGray
      
      UIScrollView.appearance().keyboardDismissMode = .onDrag
      return true
    }
}
