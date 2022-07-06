//
//  ContentView.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 19.06.2022.
//

import SwiftUI

struct ContentView: View {
  @State private var image: Image? = nil
  @State private var imageViewActive = false
  @State private var presentingPicker = false
  @State private var presentingSaved = false
  
  @StateObject private var camera = CameraVm()
  @EnvironmentObject private var platesVm: PlatesVm
  
  var body: some View {
    NavigationView {
      ZStack {
        VStack(spacing: 0) {
          cameraView
            .frame(height: Constants.cameraViewHeight)
            .clipped()
          buttonsView
            .background(.white)
          Spacer()
        }
        if camera.isTaken {
          cameraSmallButtons
        }
      }
      .navigationTitle("Licence Plate Scan")
      .navigationViewStyle(.stack)
      .navigationBarTitleDisplayMode(.inline)
    }
    .background(.green)
  }
  
  private var cameraSmallButtons: some View {
    VStack {
      HStack {
        NavigationLink(isActive: $imageViewActive, destination: {
          PlateDetailsView(presenting: $imageViewActive)
        }) {
          scanSmallButton
        }
        .padding(.leading)
        .onChange(of: imageViewActive) { if !$0 { platesVm.clearOldData() } }
        Spacer()
        retakePhotoSmallButton
          .padding(.trailing)
      }
      .padding(.top, 50)
      Spacer()
    }
  }
  
  private var scanSmallButton: some View {
    ZStack {
      Circle()
        .frame(width: 55, height: 55)
        .foregroundColor(.white)
      smallButton(with: "viewfinder.circle") {
        guard let imageData = camera.imageData,
              let uiImage = UIImage(data: imageData)?.cameraFocusArea()
        else { return }
        platesVm.tryToRecognizeText(in: uiImage)
        imageViewActive = true
      }
    }
  }
  
  private var retakePhotoSmallButton: some View {
    ZStack {
      Circle()
        .frame(width: 55, height: 55 )
        .foregroundColor(.white)
      smallButton(with: "arrow.triangle.2.circlepath.camera") {
        platesVm.clearOldData()
        camera.retakePhoto()
      }
    }
  }
  
  private var cameraView: some View {
    CameraPreview(camera: camera)
      .zIndex(-1)
      .onAppear {
        camera.checkAuthorization()
      }
  }
  
  private var takePhotoButton: some View {
    Button {
      camera.takePhoto()
    } label: {
      ZStack {
        Circle()
          .frame(width: 115)
          .foregroundColor(.white)
        Circle()
          .frame(width: 98)
          .foregroundColor(.main.opacity(0.5))
        Circle()
          .frame(width: 88)
          .foregroundColor(.white)
        Circle()
          .frame(width: 80)
          .foregroundColor(.main)
      }
    }
    .disabled(camera.isTaken)
    .frame(width: 115, height: 115)
  }
  
  private var buttonsView: some View {
    VStack {
      takePhotoButton
      Spacer()
      HStack {
        Spacer()
        presentPhotoPickerButton
        Spacer()
        toggleTorchButton
        Spacer()
        viewSavedButton
        Spacer()
      }
      .foregroundColor(Color("main"))
    }
    .offset(x: 0, y: -(115 / 2))
  }
  
  private var presentPhotoPickerButton: some View {
    smallButton(with: "photo") {}
    
  }
  
  private var toggleTorchButton: some View {
    smallButton(with: camera.torchOn ? "bolt.fill" : "bolt" ) {
      camera.toggleTorch()
    }
  }
  
  private var viewSavedButton: some View {
    NavigationLink(isActive: $presentingSaved) {
      PlateListView()
        .background(.white)
    } label: {
      smallButton(with: "clock.arrow.circlepath") {
        presentingSaved = true
      }
    }
  }
  
  private func smallButton(
    with imageName: String,
    _ action: @escaping () -> ()
  ) -> some View {
    Button {
      action()
    } label: {
      Image(systemName: imageName)
        .resizable()
        .scaledToFit()
    }
    .foregroundColor(.main)
    .frame(width: 44, height: 44)
  }
}
