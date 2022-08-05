//
//  BusinessDetailHoursView.swift
//  LocalBusinesses
//
//  Created by TamNXH on 05/08/2022.
//

import SwiftUI

struct BusinessDetailHoursView: View {
    let hours: [BusinessDetail.Hour]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hours of operation")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(hours) { hour in
                            VStack {
                                Text("\(hour.day.title)")
                                Text("\(hour.open) - \(hour.close)")
                                HStack {
                                    Text("Overnight")
                                    Image(systemName: hour.isOvernight ? "checkmark.square" : "square")
                                }
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

struct BusinessDetailHoursView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessDetailHoursView(hours: [])
    }
}
