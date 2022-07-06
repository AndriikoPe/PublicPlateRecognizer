//
//  PlateView.swift
//  PlateRecognizer
//
//  Created by Пермяков Андрей on 23.06.2022.
//

import SwiftUI

struct PlateView: View {
  let text: String
  
  var body: some View {
    ZStack {
      Image("plate")
        .resizable()
        .scaledToFit()
      Text(text)
        .font(.custom("UKNumberPlate.ttf", size: 40))
        .padding(.leading, 25)
    }
  }
}

struct PlateView_Previews: PreviewProvider {
  static var previews: some View {
    PlateView(text: "AA 0000 AA")
  }
}
