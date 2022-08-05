//
//  BusinessesConverter.swift
//  LocalBusinesses
//
//  Created by TamNXH on 04/08/2022.
//

import Foundation

final class BusinessesConverter {
    static func convertBusinessesToViewEntity(responseEntity: BusinessListAPIResponse) -> [Business] {
        return responseEntity.businesses?.map { Business(response: $0) } ?? []
    }
    
    static func convertBusinessDetailToViewEntity(responseEntity: BusinessDetailAPIResponse) -> BusinessDetail {
        return BusinessDetail(response: responseEntity)
    }
}
