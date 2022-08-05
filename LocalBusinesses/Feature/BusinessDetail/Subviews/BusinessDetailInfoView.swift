//
//  BusinessDetailInfoView.swift
//  LocalBusinesses
//
//  Created by TamNXH on 05/08/2022.
//

import SwiftUI

struct BusinessDetailInfoView: View {
    let rating: String
    let reviewCount: String
    let address: String
    let phone: String
    let phoneCall: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Rating: \(rating)")
                Text("Review count: \(reviewCount)")
                Text("Address: \(address)")
                HStack(spacing: 0) {
                    Text("Contact: ")
                    Button {
                        let phone = "tel://"
                        let phoneNumberformatted = phone + phoneCall
                        guard let url = URL(string: phoneNumberformatted) else {
                            return
                        }
                        UIApplication.shared.open(url)
                    } label: {
                        Text(phone)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

struct BusinessDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessDetailInfoView(rating: "5.0",
                               reviewCount: "20",
                               address: "Vietname",
                               phone: "1234567890",
                               phoneCall: "927912738123")
    }
}
