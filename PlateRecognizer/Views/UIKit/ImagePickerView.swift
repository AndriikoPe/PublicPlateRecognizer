//
//  ImagePickerView.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 07.07.2022.
//

import PhotosUI
import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
  @Binding var image: Image?
  
  func makeUIViewController(context: Context) -> PHPickerViewController {
    var config = PHPickerConfiguration()
    config.filter = .images
    let picker = PHPickerViewController(configuration: config)
    picker.delegate = context.coordinator
    return picker
  }
  
  func makeCoordinator() -> Coordinator { Coordinator(self) }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
  
  class Coordinator: NSObject, PHPickerViewControllerDelegate {
    let parent: ImagePickerView
    
    init(_ parent: ImagePickerView) {
      self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      picker.dismiss(animated: true)
      
      guard let provider = results.first?.itemProvider else { return }
      
      if provider.canLoadObject(ofClass: UIImage.self) {
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
          guard let uiImage = image as? UIImage else { return }
          self?.parent.image = Image(uiImage: uiImage)
        }
      }
    }
  }
}
