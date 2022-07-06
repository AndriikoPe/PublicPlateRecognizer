//
//  CameraVm.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 24.06.2022.
//

import SwiftUI
import AVFoundation

class CameraVm: NSObject, ObservableObject {
  @Published var isTaken = false
  @Published var session = AVCaptureSession()
  @Published var output = AVCapturePhotoOutput()
  @Published var imageData: Data? = nil
  @Published var torchOn = false
  
  @Published var preview: AVCaptureVideoPreviewLayer!
  
  func checkAuthorization() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { [weak self] status in
        if status { self?.setup() }
      }
    case .authorized:
      setup()
    default: return
    }
  }
  
  func setup() {
    do {
      self.session.beginConfiguration()
      
      guard let device = AVCaptureDevice.default(
        .builtInWideAngleCamera,
        for: AVMediaType.video,
        position: .back
      ) else {
        print("Failed to get camera")
        return
      }
      
      let input = try AVCaptureDeviceInput(device: device)
      
      if self.session.canAddInput(input) {
        self.session.addInput(input)
      }
      
      if self.session.canAddOutput(self.output) {
        self.session.addOutput(self.output)
      }
      
      self.session.commitConfiguration()
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func retakePhoto() {
    DispatchQueue.global(qos: .background).async {
      self.session.startRunning()
      
      DispatchQueue.main.async {
        withAnimation {
          self.isTaken = false
          self.imageData = nil
        }
      }
    }
  }
  
  func takePhoto() {
    DispatchQueue.global(qos: .userInitiated).async {
      self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
  }
  
  func toggleTorch() {
    guard let device = AVCaptureDevice.default(for: AVMediaType.video),
          device.hasTorch else { return }
    do {
      try device.lockForConfiguration()
      device.torchMode = (device.torchMode == .off) ? .on : .off
      self.torchOn = device.torchMode == .on
      device.unlockForConfiguration()
    } catch {
      print("Torch can't be used")
    }
  }
}

extension CameraVm: AVCapturePhotoCaptureDelegate {
  func photoOutput(
    _ output: AVCapturePhotoOutput,
    didFinishProcessingPhoto photo: AVCapturePhoto,
    error: Error?
  ) {
    guard let imageData = photo.fileDataRepresentation() else { return }
    self.session.stopRunning()
    self.imageData = imageData
    withAnimation { self.isTaken = true }
  }
}
