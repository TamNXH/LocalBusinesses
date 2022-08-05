//
//  NetworkServices.swift
//  LocalBusinesses
//
//  Created by TamNXH on 03/08/2022.
//

import Foundation
import Combine

final class NetworkServices {
    private let enableDebugHttpInfo = true
    private let defaultTimeout = 30.0
    private let defaultCachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    
    private let jsonHeaderValue: String = "application/json"
    private let httpField: String = "Content-Type"
    
    private var session: URLSession = .shared
    
    static let shared = NetworkServices()
    
    private init() {}
    
    func setUpURLSessionForTest(_ urlSession: URLSession) {
        session = urlSession
    }
}

// MARK: - Public functions, conform to NetworkServicesProtocol
extension NetworkServices: NetworkServicesProtocol {
    func request(info: RequestInfo) -> AnyPublisher<Data, NetworkError> {
        do {
            if enableDebugHttpInfo {
                Logger.http(request)
            }
            
            let request = try createRequest(info)
            
            return session.dataTaskPublisher(for: request)
            // TODO - If we need to handle http status code, using `trymap`
            // to get http status code. If not, just use `mapError` and `map`
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw NetworkError.serverFailed("HTTPS status not valid: \(response)")
                    }
                    return data
                }
                .mapError { error in
                    return NetworkError.serverFailed("Server failed with error \(error)")
                }
                .eraseToAnyPublisher()
        } catch let error as NetworkError {
            Logger.server("Create request failed:", error.localizedDescription)
            return Fail(error: error).eraseToAnyPublisher()
        } catch let error {
            Logger.server("Create request failed:", error.localizedDescription)
            return Fail(error: NetworkError.parametersNil("")).eraseToAnyPublisher()
        }
    }
}

// MARK: - Private functions
private extension NetworkServices {
    func createRequest(_ requestInfo: RequestInfo) throws -> URLRequest {
        let urlInfo: HTTPURLInfo = requestInfo.urlInfo
        
        let components = buildURLComponent(urlInfo)
        
        guard let url = components.url else {
            throw NetworkError.missingURL("")
        }
        
        var request = URLRequest(url: url, cachePolicy: defaultCachePolicy, timeoutInterval: defaultTimeout)
        request.httpMethod = requestInfo.httpMethod.rawValue
        request.setHeaderRequest()
        
        do {
            switch requestInfo.task {
            case .request:
                request.setValue(jsonHeaderValue, forHTTPHeaderField: httpField)
                
            case .requestParameters(let bodyParams, let bodyEncoding, let urlParams):
                try configureParameters(bodyParameters: bodyParams,
                                        bodyEncoding: bodyEncoding,
                                        urlParameters: urlParams,
                                        request: &request)
                
            case .requestParametersAndHeaders(let bodyParams, let bodyEncoding, let urlParams, let headerParams):
                addAdditionalHeaders(headerParams, request: &request)
                
                try configureParameters(bodyParameters: bodyParams,
                                        bodyEncoding: bodyEncoding,
                                        urlParameters: urlParams,
                                        request: &request)
            }
        } catch let error {
            Logger.server("Create request failed", error.localizedDescription)
            throw error
        }
        
        return request
    }
    
    /// Config parameters for url body and request body
    /// - Parameters:
    ///   - bodyParameters: Post request body parameters
    ///   - bodyEncoding: Body encoding type
    ///   - urlParameters: HTTP request paramsters
    ///   - request: URLRequest need to config (will return)
    /// - Throws: NetworkError instance
    func configureParameters(bodyParameters: Parameters?,
                             bodyEncoding: ParameterEncoding,
                             urlParameters: Parameters?,
                             request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters,
                                    urlParameters: urlParameters)
        } catch let error {
            Logger.server("Config parameters failed", error.localizedDescription)
            throw NetworkError.encodingFailed("")
        }
    }
    
    /// Add custome header to request
    /// - Parameters:
    ///   - additionalHeaders: header filed need to add
    ///   - request: URLRequest need to config (will return)
    func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    func buildURLComponent(_ urlInfo: HTTPURLInfo) -> URLComponents {
        var components = URLComponents()
        
        components.scheme = urlInfo.scheme
        components.host = urlInfo.host
        components.path = urlInfo.path
        
        return components
    }
}
