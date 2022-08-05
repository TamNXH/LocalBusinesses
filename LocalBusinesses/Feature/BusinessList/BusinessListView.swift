//
//  BusinessListView.swift
//  LocalBusinesses
//
//  Created by TamNXH on 04/08/2022.
//

import SwiftUI

struct BusinessListView: View {
    @ObservedObject private(set) var viewModel: BusinessListViewModel
    
    init() {
        viewModel = BusinessListViewModel()
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: .zero) {
                Text("Local Business")
                    .padding()
                
                ZStack {
                    ContentView(contentViewModel: viewModel)
                    
                    // No data view
                    Text("Data Empty")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color.gray)
                        .opacity(viewModel.isShowingNoData ? 1 : 0)
                }
            }
            .navigationBarHidden(true)
        }
        .alert(isPresented: $viewModel.isShowingAlert, content: {
            if viewModel.isNeedRequestLocation {
                return Alert(title: Text("Setting Location"),
                             message: Text("Please go to Settings and turn on the permissions"),
                             primaryButton: .default(Text("Setting"), action: {
                    viewModel.isNeedRequestLocation = false
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                    }
                }),
                             secondaryButton: .default(Text("Cancel"), action: {
                    viewModel.isNeedRequestLocation = false
                }))
            } else {
                return Alert(title: Text("Error"),
                             message: Text(viewModel.errorMess),
                             dismissButton: .default(Text("Ok")))
            }
        })
    }
}

// MARK: - ContentView

extension BusinessListView {
    
    struct ContentView: View {
        @ObservedObject var contentViewModel: BusinessListViewModel
        
        var body: some View {
            VStack(spacing: 0) {
                BusinessListSearchView(searchValue: $contentViewModel.searchValue,
                                       searchType: $contentViewModel.searchType,
                                       sortType: $contentViewModel.sortType,
                                       searchAction: {
                    contentViewModel.getListBusiness(isLoadmore: false)
                })
                    .padding([.horizontal, .bottom], 8)
                List {
                    makeList()
                }
                .listStyle(PlainListStyle())
                .environment(\.defaultMinListRowHeight, 0)
            }
        }
        
        // MARK: - Private Methods
        
        /// make content list
        /// - Returns: some View
        private func makeList() -> some View {
            ForEach(contentViewModel.bussinesses) { item in
                ZStack {
                    BusinessListItemView(imageUrl: item.imageUrl,
                                         businessName: item.businessName,
                                         distance: item.distance,
                                         rating: item.rating)
                    NavigationLink(destination: NavigationLazyView(BusinessDetailView(businessId: item.BusinessId,
                                                                                      businessName: item.businessName))) {
                        EmptyView()
                    }
                                                                                      .opacity(0)
                }
                .onAppear {
                    itemWillAppear(width: item.id)
                }
            }
        }
        
        /// call when item will appear
        /// - Parameter id: UUID
        private func itemWillAppear(width id: UUID) {
            guard id == contentViewModel.bussinesses.last?.id, contentViewModel.isHasMore else {
                return
            }
            contentViewModel.getListBusiness(isLoadmore: true)
        }
    }
}
