//
//  ByteRenderView.swift
//  IpfsExample
//
//  Created by Jure Granić-Skender on 08.08.2023..
//

import Foundation
import SwiftUI

struct ByteRenderView: View {
    let data: Data
    
    var body: some View {
        if let text = String(data: data, encoding: .utf8) {
            // If the data can be decoded as text, render it as Text
            Text(text)
                .font(.system(size: 18))
                .padding()
        } else if let uiImage = UIImage(data: data) {
            // If the data can be converted to an image, render it as Image
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .padding()
        } else {
            Text("Unsupported byte format")
                .font(.system(size: 18))
                .padding()
        }
    }
}
