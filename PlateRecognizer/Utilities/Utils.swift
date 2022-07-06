//
//  Utils.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 25.06.2022.
//

import SwiftUI

extension Color {
  static let main = Color("main")
}

extension UIImage { 
  func cameraFocusArea() -> UIImage? {
    let croppingHeight = size.width * Constants.cameraFocusRectWidthFactor /
      Constants.cameraFocusAspectRatio
    
    let croppingRect = CGRect(
      x: (size.height - croppingHeight) * 0.5,
      y: size.width * (1.0 - Constants.cameraFocusRectWidthFactor) * 0.5,
      width: croppingHeight,
      height: size.width * Constants.cameraFocusRectWidthFactor
    )
    
    guard let croppedImage = cgImage?.cropping(to: croppingRect) else {
      print("Failed to crop image!")
      return nil
    }
    
    let result = UIImage(cgImage: croppedImage, scale: 1, orientation: self.imageOrientation)
    return result
  }
}
