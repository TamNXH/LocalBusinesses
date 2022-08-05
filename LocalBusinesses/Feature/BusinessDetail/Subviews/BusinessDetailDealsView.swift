//
//  BusinessDetailDealsView.swift
//  LocalBusinesses
//
//  Created by TamNXH on 05/08/2022.
//

import SwiftUI

struct BusinessDetailDealsView: View {
    let specialHour: [BusinessDetail.SpecialHour]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Special hours")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(specialHour) { hour in
                            VStack {
                                Text("\(hour.date)")
                                Text("\(hour.start) - \(hour.end)")
                            }
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(8)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

struct BusinessDetailDealsView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessDetailDealsView(specialHour: [])
    }
}
