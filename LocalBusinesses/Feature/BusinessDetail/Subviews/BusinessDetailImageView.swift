//
//  BusinessDetailImageView.swift
//  LocalBusinesses
//
//  Created by TamNXH on 05/08/2022.
//

import SwiftUI

struct BusinessDetailImageView: View {
    @ObservedObject var imageFromUrl: ImageFromUrl
    
    init(image: String) {
        imageFromUrl = ImageFromUrl(urlString: image)
    }
    
    var body: some View {
        Image(uiImage: imageFromUrl.image ?? #imageLiteral(resourceName: "online-shop"))
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
