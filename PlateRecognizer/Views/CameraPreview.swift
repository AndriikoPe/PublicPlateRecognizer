//
//  CameraPreview.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 20.06.2022.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
  @ObservedObject var camera: CameraVm
  
  func makeUIView(context: Context) -> some UIView {
    let viewFrame = CGRect(
      x: 0,y: 0,
      width: UIScreen.main.bounds.width,
      height: Constants.cameraViewHeight
    )
    let view = UIView(frame: viewFrame)
    camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
    camera.preview.frame = view.frame
    
    camera.preview.videoGravity = .resizeAspectFill
    view.layer.addSublayer(camera.preview)
    
    let scannerOverlayPreviewLayer = ScannerOverlayPreviewLayer(session: camera.session)
    scannerOverlayPreviewLayer.frame = view.bounds
    let overlayWidth = view.bounds.width * Constants.cameraFocusRectWidthFactor
    scannerOverlayPreviewLayer.maskSize = CGSize(
      width: overlayWidth,
      height: overlayWidth / Constants.cameraFocusAspectRatio
    )

    scannerOverlayPreviewLayer.videoGravity = .resizeAspectFill
    view.layer.addSublayer(scannerOverlayPreviewLayer)
    
    camera.session.startRunning()
    return view
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {}
}

