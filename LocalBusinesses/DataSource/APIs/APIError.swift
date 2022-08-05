//
//  APIError.swift
//  LocalBusinesses
//
//  Created by TamNXH on 03/08/2022.
//

import Foundation

enum APIError: Error {
    case urlFailed(String)
    case parsingError(String)
    case httpError(String)
    case serverFailed(String)
    case unknown
}
