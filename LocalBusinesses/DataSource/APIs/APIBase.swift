//
//  APIBase.swift
//  LocalBusinesses
//
//  Created by TamNXH on 03/08/2022.
//

import Foundation
import Combine

class APIBase {
    /// decode
    /// - Parameter data: Data
    /// - Returns: AnyPublisher<T, APIError>
    func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, APIError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                Logger.debug(error)
                do {
                    let serverErrorResponse = try decoder.decode(CommonErrorAPIResponse.self, from: data)
                    Logger.server(serverErrorResponse)
                    return APIError.parsingError("\(serverErrorResponse.error.description)")
                } catch let error {
                    return APIError.parsingError("Error: \(error)")
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// Prepare url info for request
    /// - Parameters:
    ///   - scheme: scheme for request, http or https. Default `ServerConstant.URLBase.scheme`
    ///   - host: host for request, example: google.com. Default `ServerConstant.URLBase.host`
    ///   - path: path for request, example: api/v1. Default `ServerConstant.URLBase.path`
    /// - Returns: `HTTPURLInfo` instance
    func prepareURLInfoRelease(scheme: String = ServerConstant.URLBaseRelease.scheme,
                               host: String = ServerConstant.URLBaseRelease.host,
                               path: String = ServerConstant.URLBaseRelease.path) -> HTTPURLInfo {
        let urlInfo = (HTTPURLInfo(scheme: scheme, host: host, path: path))
        
        return urlInfo
    }
}
