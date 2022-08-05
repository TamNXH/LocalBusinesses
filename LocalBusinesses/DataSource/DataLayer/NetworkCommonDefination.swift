//
//  NetworkCommonDefination.swift
//  LocalBusinesses
//
//  Created by TamNXH on 03/08/2022.
//

import Foundation

// swiftlint:disable colon

public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}

public typealias HTTPHeaders    = [String: String]
public typealias Parameters     = [String: Any]

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
                           bodyEncoding: ParameterEncoding,
                           urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
                                     bodyEncoding: ParameterEncoding,
                                     urlParameters: Parameters?,
                                     additionHeaders: HTTPHeaders?)
}

public enum NetworkError: Error {
    // Check request info
    case missingURL(String)
    case parametersNil(String)
    case encodingFailed(String)
    // Server
    case serverNotFound(String)
    case serverFailed(String)
    case unknown(String)
}

public struct HTTPURLInfo {
    let scheme: String
    let host:   String
    let path:   String
}

public struct RequestInfo {
    var urlInfo:    HTTPURLInfo
    var httpMethod: HTTPMethod
    var header:     HTTPHeaders?
    var task:       HTTPTask
}
