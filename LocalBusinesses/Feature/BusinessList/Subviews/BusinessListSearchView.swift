//
//  BusinessListSearchView.swift
//  LocalBusinesses
//
//  Created by TamNXH on 04/08/2022.
//

import SwiftUI

struct BusinessListSearchView: View {
    @Binding var searchValue: String
    @Binding var searchType: SearchType
    @Binding var sortType: SortType
    
    var searchAction: (() -> Void)?
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search local businesses",
                          text: $searchValue)
                
                if !searchValue.isEmpty {
                    Button {
                        searchValue = ""
                        searchAction?()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
                
                Button {
                    searchAction?()
                } label: {
                    Text("Search")
                }
            }
            .padding()
            .background(Color.gray)
            .cornerRadius(8)
            
            HStack {
                Text("Search by:")
                ForEach(SearchType.allCases) { type in
                    if type == searchType {
                        Text(type.title)
                            .padding(4)
                            .background(Color.orange)
                            .cornerRadius(4)
                    } else {
                        Button {
                            searchType = type
                            searchAction?()
                        } label: {
                            Text(type.title)
                        }
                    }
                }
                Spacer()
            }
            
            HStack {
                Text("Sort by:")
                ForEach(SortType.allCases) { type in
                    if type == sortType {
                        Text(type.title)
                            .padding(4)
                            .background(Color.orange)
                            .cornerRadius(4)
                    } else {
                        Button {
                            sortType = type
                            searchAction?()
                        } label: {
                            Text(type.title)
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

struct BusinessListSearchView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessListSearchView(searchValue: .constant("steak"),
                               searchType: .constant(.businessName),
                               sortType: .constant(.rating))
    }
}
