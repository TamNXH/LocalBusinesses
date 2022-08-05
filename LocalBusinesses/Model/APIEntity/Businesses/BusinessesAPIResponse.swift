//
//  BusinessesAPIResponse.swift
//  LocalBusinesses
//
//  Created by TamNXH on 03/08/2022.
//

import Foundation

// MARK: - BusinessListAPIResponse
struct BusinessListAPIResponse: Codable {
    let businesses: [Business]?
    let total: Int
    let region: Region?
    
    // MARK: - Business
    struct Business: Codable {
        let id: String
        let alias, name: String?
        let imageURL: String?
        let isClosed: Bool?
        let url: String?
        let reviewCount: Int?
        let categories: [Category]?
        let rating: Double?
        let coordinates: Center?
        let transactions: [String]?
        let price: String?
        let location: Location?
        let phone, displayPhone: String?
        let distance: Double?
        
        enum CodingKeys: String, CodingKey {
            case id, alias, name
            case imageURL = "image_url"
            case isClosed = "is_closed"
            case url
            case reviewCount = "review_count"
            case categories, rating, coordinates, transactions, price, location, phone
            case displayPhone = "display_phone"
            case distance
        }
    }
    
    // MARK: - Category
    struct Category: Codable {
        let alias, title: String?
    }
    
    // MARK: - Center
    struct Center: Codable {
        let latitude, longitude: Double?
    }
    
    // MARK: - Location
    struct Location: Codable {
        let address1: String?
        let address2: String?
        let address3: String?
        let city: String?
        let zipCode: String?
        let country: String?
        let state: String?
        let displayAddress: [String]?
        
        enum CodingKeys: String, CodingKey {
            case address1, address2, address3, city
            case zipCode = "zip_code"
            case country, state
            case displayAddress = "display_address"
        }
    }
    
    // MARK: - Region
    struct Region: Codable {
        let center: Center?
    }
}

// MARK: - BusinessDetailAPIResponse
struct BusinessDetailAPIResponse: Codable {
    let id: String
    let alias, name: String?
    let imageURL: String?
    let isClaimed, isClosed: Bool?
    let url: String?
    let phone, displayPhone: String?
    let reviewCount: Int?
    let categories: [Category]?
    let rating: Double?
    let location: Location?
    let coordinates: Coordinates?
    let photos: [String]?
    let price: String?
    let hours: [Hour]?
    let transactions: [String]?
    let specialHours: [SpecialHour]?
    
    enum CodingKeys: String, CodingKey {
        case id, alias, name
        case imageURL = "image_url"
        case isClaimed = "is_claimed"
        case isClosed = "is_closed"
        case url, phone
        case displayPhone = "display_phone"
        case reviewCount = "review_count"
        case categories, rating, location, coordinates, photos, price, hours, transactions
        case specialHours = "special_hours"
    }
    
    // MARK: - Category
    struct Category: Codable {
        let alias, title: String?
    }
    
    // MARK: - Coordinates
    struct Coordinates: Codable {
        let latitude, longitude: Double?
    }
    
    // MARK: - Hour
    struct Hour: Codable {
        let hourOpen: [Open]?
        let hoursType: String?
        let isOpenNow: Bool?
        
        enum CodingKeys: String, CodingKey {
            case hourOpen = "open"
            case hoursType = "hours_type"
            case isOpenNow = "is_open_now"
        }
    }
    
    // MARK: - Open
    struct Open: Codable {
        let isOvernight: Bool?
        let start, end: String?
        let day: Int?
        
        enum CodingKeys: String, CodingKey {
            case isOvernight = "is_overnight"
            case start, end, day
        }
    }
    
    // MARK: - Location
    struct Location: Codable {
        let address1, address2: String?
        let address3: String?
        let city, zipCode, country, state: String?
        let displayAddress: [String]
        let crossStreets: String?
        
        enum CodingKeys: String, CodingKey {
            case address1, address2, address3, city
            case zipCode = "zip_code"
            case country, state
            case displayAddress = "display_address"
            case crossStreets = "cross_streets"
        }
    }
    
    // MARK: - Special Hour
    struct SpecialHour: Codable {
        let date: String?
        let isClosed: Bool?
        let start: String?
        let end: String?
        let idOvernight: Bool?
        
        enum CodingKeys: String, CodingKey {
            case date, start, end
            case isClosed = "is_closed"
            case idOvernight = "is_overnight"
        }
    }
}
