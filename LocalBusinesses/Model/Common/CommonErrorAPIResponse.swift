//
//  CommonErrorAPIResponse.swift
//  LocalBusinesses
//
//  Created by TamNXH on 03/08/2022.
//

import Foundation

struct CommonErrorAPIResponse: Codable {
    let error: Error
    
    struct Error: Codable {
        let code: String
        let description: String
        let field: String?
        let instance: String?
    }
}
