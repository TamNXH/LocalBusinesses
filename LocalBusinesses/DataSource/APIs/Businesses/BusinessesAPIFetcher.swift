//
//  BusinessesAPIFetcher.swift
//  LocalBusinesses
//
//  Created by TamNXH on 03/08/2022.
//

import Foundation
import Combine

protocol BusinessesAPIFetcherProtocol: AnyObject {
    func fetchBusinessList(term: String,
                           categories: String,
                           location: String,
                           latitude: Double,
                           longitude: Double,
                           offset: Int,
                           limit: Int,
                           sortBy: String) -> AnyPublisher<BusinessListAPIResponse, APIError>
    func fetchBusinessDetail(businessId: String) -> AnyPublisher<BusinessDetailAPIResponse, APIError>
}

final class BusinessesAPIFetcher: APIBase {
    private let networkServices: NetworkServices = NetworkServices.shared
}

// MARK: - BusinessesAPIFetcherProtocol

extension BusinessesAPIFetcher: BusinessesAPIFetcherProtocol {
    func fetchBusinessList(term: String,
                           categories: String,
                           location: String,
                           latitude: Double,
                           longitude: Double,
                           offset: Int,
                           limit: Int,
                           sortBy: String) -> AnyPublisher<BusinessListAPIResponse, APIError> {
        // Prepare URL info
        let urlInfo: HTTPURLInfo = prepareURLInfoRelease(path: "/v3/businesses/search")
        
        // Prepare http method
        let httpMethod: HTTPMethod = .get
        
        // Prepare task
        var urlParameters: Parameters = ["offset": "\(offset)",
                                         "limit": "\(limit)",
                                         "sort_by": "\(sortBy)"]
        
        if location.isEmpty {
            urlParameters["latitude"] = latitude
            urlParameters["longitude"] = longitude
        } else {
            urlParameters["location"] = location
        }
        
        if !term.isEmpty {
            urlParameters["term"] = term
        }
        
        if !categories.isEmpty {
            urlParameters["categories"] = categories
        }
        
        let taskRequest: HTTPTask = .requestParameters(bodyParameters: nil,
                                                       bodyEncoding: .urlEncoding,
                                                       urlParameters: urlParameters)
        
        // Request info
        let requestInfo: RequestInfo = RequestInfo(urlInfo: urlInfo, httpMethod: httpMethod, header: nil, task: taskRequest)
        
        return networkServices.request(info: requestInfo)
            .mapError { (error) in
                Logger.debug(error)
                return APIError.urlFailed("\(error)")
            }
            .flatMap(maxPublishers: .max(1), { [weak self] (data) -> AnyPublisher<BusinessListAPIResponse, APIError> in
                guard let self = self else {
                    let error = APIError.parsingError
                    return Fail(error: error("Fetcher released before have response")).eraseToAnyPublisher()
                }
                
                return self.decode(data)
            })
            .eraseToAnyPublisher()
    }
    
    func fetchBusinessDetail(businessId: String) -> AnyPublisher<BusinessDetailAPIResponse, APIError> {
        // Prepare URL info
        let urlInfo: HTTPURLInfo = prepareURLInfoRelease(path: "/v3/businesses/\(businessId)")
        
        // Prepare http method
        let httpMethod: HTTPMethod = .get
        
        let taskRequest: HTTPTask = .requestParameters(bodyParameters: nil,
                                                       bodyEncoding: .urlEncoding,
                                                       urlParameters: nil)
        
        // Request info
        let requestInfo: RequestInfo = RequestInfo(urlInfo: urlInfo, httpMethod: httpMethod, header: nil, task: taskRequest)
        
        return networkServices.request(info: requestInfo)
            .mapError { (error) in
                Logger.debug(error)
                return APIError.urlFailed("\(error)")
            }
            .flatMap(maxPublishers: .max(1), { [weak self] (data) -> AnyPublisher<BusinessDetailAPIResponse, APIError> in
                guard let self = self else {
                    let error = APIError.parsingError
                    return Fail(error: error("Fetcher released before have response")).eraseToAnyPublisher()
                }
                
                return self.decode(data)
            })
            .eraseToAnyPublisher()
    }
}
