//
//  BusinessListViewModel.swift
//  LocalBusinesses
//
//  Created by TamNXH on 04/08/2022.
//

import Foundation
import Combine
import CoreLocation

class BusinessListViewModel: NSObject, ObservableObject {
    @Published var isShowingNoData: Bool = false
    @Published var isShowingAlert: Bool = false
    @Published var searchValue: String = ""
    @Published var bussinesses: [Business] = []
    @Published var searchType: SearchType = .businessName
    @Published var sortType: SortType = .rating
    
    var isHasMore: Bool = true
    var errorMess: String = ""
    var isNeedRequestLocation: Bool = false
    
    private let limit: Int = 20
    private var offset: Int = 0
    private var isNeedLoad: Bool = true
    private var userLatitude: Double = .zero
    private var userLongitude: Double = .zero
    
    private let businessesFetcher: BusinessesAPIFetcher = BusinessesAPIFetcher()
    private var disposables = Set<AnyCancellable>()
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - ViewEntity

enum SearchType: CaseIterable {
    case businessName
    case location
    case cuisine
    
    var title: String {
        switch self {
        case .businessName:
            return "Business name"
        case .location:
            return "Location"
        case .cuisine:
            return "Cuisine"
        }
    }
}

extension SearchType: Identifiable {
    var id: UUID { return UUID() }
}

enum SortType: String, CaseIterable {
    case rating
    case distance
    
    var title: String {
        switch self {
        case .rating:
            return "Rating"
        case .distance:
            return "Distance"
        }
    }
}

extension SortType: Identifiable {
    var id: UUID { return UUID() }
}

struct Business: Identifiable {
    let id: UUID = UUID()
    let BusinessId: String
    let imageUrl: String
    let businessName: String
    let distance: String
    let rating: String
    
    init(response: BusinessListAPIResponse.Business) {
        BusinessId = response.id
        imageUrl = response.imageURL ?? ""
        businessName = response.name ?? ""
        distance = "\(response.distance ?? .zero)"
        rating = "\(response.rating ?? .zero)"
    }
}

extension BusinessListViewModel {
    
    /// Get list business items
    /// - Parameter isLoadmore: Bool
    func getListBusiness(isLoadmore: Bool) {
        if !isLoadmore || !isHasMore {
            offset = 0
        }
        
        var term: String
        var location: String
        var categories: String
        
        switch searchType {
        case .location:
            location = searchValue
            term = ""
            categories = ""
        case .businessName:
            location = ""
            categories = ""
            term = searchValue
        case .cuisine:
            location = ""
            categories = searchValue
            term = ""
        }
        
        businessesFetcher.fetchBusinessList(term: term,
                                            categories: categories,
                                            location: location,
                                            latitude: userLatitude,
                                            longitude: userLongitude,
                                            offset: offset,
                                            limit: limit,
                                            sortBy: sortType.rawValue)
            .map { response in
                return BusinessesConverter.convertBusinessesToViewEntity(responseEntity: response)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else {
                    return
                }
                
                switch value {
                case .failure (let error):
                    Logger.debug(error)
                    self.bussinesses.removeAll()
                    self.isShowingNoData = true
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] listItem in
                guard let self = self else {
                    return
                }
                
                Logger.server(listItem)
                self.offset += 1
                if !isLoadmore {
                    // case first load or pull to refresh
                    self.bussinesses.removeAll()
                }
                
                self.bussinesses += listItem
                
                self.isHasMore = listItem.count >= self.limit
                self.isShowingNoData = self.bussinesses.isEmpty
            })
            .store(in: &disposables)
    }
}

// MARK: - NSObject, CLLocationManagerDelegate

extension BusinessListViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
            break
        case .restricted, .denied:
            isNeedRequestLocation = true
            isShowingAlert = true
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
        
        if isNeedLoad {
            isNeedLoad = false
            getListBusiness(isLoadmore: false)
        }
    }
}
