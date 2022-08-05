//
//  BusinessDetailViewModel.swift
//  LocalBusinesses
//
//  Created by TamNXH on 04/08/2022.
//

import Foundation
import Combine

class BusinessDetailViewModel: ObservableObject {
    @Published var imageUrl: String = ""
    @Published var categories: [BusinessDetail.Category] = []
    @Published var address: String = ""
    @Published var phone: String = ""
    @Published var hours: [BusinessDetail.Hour] = []
    @Published var specialHours: [BusinessDetail.SpecialHour] = []
    @Published var rating: String = ""
    @Published var reviewCount: String = ""
    @Published var isShowingNoData: Bool = false
    @Published var phoneCall: String = ""
    
    let businessName: String
    
    private let businessesFetcher: BusinessesAPIFetcher = BusinessesAPIFetcher()
    private var disposables = Set<AnyCancellable>()
    
    init(businessId: String, businessName: String) {
        self.businessName = businessName
        getBusinessDetail(businessId: businessId)
    }
    
    // MARK: - Private Methods
    
    private func getBusinessDetail(businessId: String) {
        businessesFetcher.fetchBusinessDetail(businessId: businessId)
            .map { response in
                return BusinessesConverter.convertBusinessDetailToViewEntity(responseEntity: response)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else {
                    return
                }
                
                switch value {
                case .failure (let error):
                    Logger.debug(error)
                    self.isShowingNoData = true
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] businessDetail in
                guard let self = self else {
                    return
                }
                
                Logger.server(businessDetail)
                
                self.reviewCount = businessDetail.reviewCount
                self.rating = businessDetail.rating
                self.specialHours = businessDetail.specialHours
                self.phone = businessDetail.phone
                self.address = businessDetail.address
                self.hours = businessDetail.hours
                self.imageUrl = businessDetail.imageUrl
                self.categories = businessDetail.categories
                self.phoneCall = businessDetail.phoneCall
            })
            .store(in: &disposables)
    }
}

// MARK: - View Entity

struct BusinessDetail {
    let imageUrl: String
    let categories: [Category]
    let address: String
    let phone: String
    let hours: [Hour]
    let specialHours: [SpecialHour]
    let rating: String
    let reviewCount: String
    let phoneCall: String
    
    struct Category: Identifiable {
        let id: UUID = UUID()
        let title: String
    }
    
    struct Hour: Identifiable {
        let id: UUID = UUID()
        let day: DayOfWeek
        let open: String
        let close: String
        let isOvernight: Bool
    }
    
    struct SpecialHour: Identifiable {
        let id: UUID = UUID()
        let date: String
        let start: String
        let end: String
    }
    
    init(response: BusinessDetailAPIResponse) {
        imageUrl = response.imageURL ?? ""
        categories = response.categories?.map({ Category(title: $0.title ?? "") }) ?? []
        address = response.location?.displayAddress.joined(separator: ", ") ?? ""
        phone = response.displayPhone ?? ""
        hours = response.hours?.first?.hourOpen?.map({ Hour(day: DayOfWeek(rawValue: $0.day ?? .zero) ?? .mon,
                                                            open: $0.start ?? "",
                                                            close: $0.end ?? "",
                                                            isOvernight: $0.isOvernight ?? false) }) ?? []
        specialHours = response.specialHours?.map({ SpecialHour(date: $0.date ?? "",
                                                                start: $0.start ?? "",
                                                                end: $0.end ?? "") }) ?? []
        rating = "\(response.rating ?? .zero)"
        reviewCount = "\(response.reviewCount ?? .zero)"
        phoneCall = response.phone ?? ""
    }
}

enum DayOfWeek: Int {
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    case sun
    
    var title: String {
        switch self {
        case .mon:
            return "Monday"
        case .tue:
            return "Tuesday"
        case .wed:
            return "Wednesday"
        case .thu:
            return "Thursday"
        case .fri:
            return "Friday"
        case .sat:
            return "Saturday"
        case .sun:
            return "Sunday"
        }
    }
}
