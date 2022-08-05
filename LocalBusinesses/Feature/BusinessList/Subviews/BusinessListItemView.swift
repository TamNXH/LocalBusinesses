//
//  BusinessListItemView.swift
//  LocalBusinesses
//
//  Created by TamNXH on 04/08/2022.
//

import SwiftUI

struct BusinessListItemView: View {
    let imageUrl: String
    let businessName: String
    let distance: String
    let rating: String
    let isClosed: Bool
    
    var body: some View {
        HStack {
            BusinessListItemImageView(image: imageUrl)
            
            VStack(alignment: .leading) {
                Text(businessName)
                Text("Rating: \(rating)")
                Text("Distance: \(distance)")
            }
            
            Spacer(minLength: 0)
            
            Image(systemName: isClosed ? "lock.fill" : "lock.open.fill")
        }
        .padding()
    }
}

// MARK: - PreviewProvider

struct BusinessListItemView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessListItemView(imageUrl: "https://s3-media1.fl.yelpcdn.com/bphoto/gyeXuabQQpblvZ5lzVSjeg/o.jpg",
                             businessName: "Steam - Shanghai Asian Fusion",
                             distance: "3362.6951826521286",
                             rating: "5.0",
                             isClosed: true)
    }
}

// MARK: - BusinessListItemImageView

struct BusinessListItemImageView: View {
    @ObservedObject var imageFromUrl: ImageFromUrl
    
    init(image: String) {
        imageFromUrl = ImageFromUrl(urlString: image)
    }
    
    var body: some View {
        Image(uiImage: imageFromUrl.image ?? #imageLiteral(resourceName: "online-shop"))
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 68, height: 68)
    }
}
