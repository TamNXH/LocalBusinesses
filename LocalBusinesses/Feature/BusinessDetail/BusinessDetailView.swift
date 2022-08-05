//
//  BusinessDetailView.swift
//  LocalBusinesses
//
//  Created by TamNXH on 04/08/2022.
//

import SwiftUI

struct BusinessDetailView: View {
    @ObservedObject private(set) var viewModel: BusinessDetailViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(businessId: String, businessName: String) {
        viewModel = BusinessDetailViewModel(businessId: businessId,
                                            businessName: businessName)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            navigation()
            
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
    
    // MARK: - Navigation View
    
    /// create navigation
    /// - Returns: some View
    private func navigation() -> some View {
        ZStack {
            Text(viewModel.businessName)
                .padding()
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - ContentView

extension BusinessDetailView {
    
    struct ContentView: View {
        @ObservedObject var contentViewModel: BusinessDetailViewModel
        
        var body: some View {
            ScrollView(.vertical) {
                VStack {
                    BusinessDetailImageView(image: contentViewModel.imageUrl)
                        .frame(height: 200)
                    BusinessDetailInfoView(rating: contentViewModel.rating,
                                           reviewCount: contentViewModel.reviewCount,
                                           address: contentViewModel.address,
                                           phone: contentViewModel.phone,
                                           phoneCall: contentViewModel.phoneCall)
                    
                    if !contentViewModel.categories.isEmpty {
                        BusinessDetailCategoriesView(categories: contentViewModel.categories)
                    }
                    
                    if !contentViewModel.hours.isEmpty {
                        BusinessDetailHoursView(hours: contentViewModel.hours)
                    }
                    
                    if !contentViewModel.specialHours.isEmpty {
                        BusinessDetailDealsView(specialHour: contentViewModel.specialHours)
                    }
                    
                    if !contentViewModel.photos.isEmpty {
                        BusinessDetailPhotosView(photos: contentViewModel.photos)
                    }
                }
            }
        }
    }
}
