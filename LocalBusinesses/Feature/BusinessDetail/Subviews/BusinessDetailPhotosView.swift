//
//  BusinessDetailPhotosView.swift
//  LocalBusinesses
//
//  Created by TamNXH on 05/08/2022.
//

import SwiftUI

struct BusinessDetailPhotosView: View {
    let photos: [BusinessDetail.Photo]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Photos:")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(photos) { photo in
                        BusinessDetailImageView(image: photo.url)
                            .frame(height: 100)
                    }
                }
            }
        }
        .padding()
    }
}

struct BusinessDetailPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessDetailPhotosView(photos: [])
    }
}
