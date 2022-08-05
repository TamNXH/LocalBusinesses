//
//  BusinessDetailCategoriesView.swift
//  LocalBusinesses
//
//  Created by TamNXH on 05/08/2022.
//

import SwiftUI

struct BusinessDetailCategoriesView: View {
    let categories: [BusinessDetail.Category]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Categories:")
                
                ForEach(categories) { category in
                    Text("\(category.title)")
                        .padding(.leading, 8)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

struct BusinessDetailCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessDetailCategoriesView(categories: [])
    }
}
