//
//  StringExtensions.swift
//  LocalBusinesses
//
//  Created by TamNXH on 03/08/2022.
//

import Foundation
import UIKit

public extension String {
    
    static let empty: String = ""
    static let zero: String = "0"
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let sizeText: CGSize = self.size(withAttributes: fontAttributes)
        return sizeText.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let sizeText: CGSize = self.size(withAttributes: fontAttributes)
        return sizeText.height
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func convertJSONPToJSON(fromStart: String, toEnd: String) -> String {
        let splitFirstString = self.components(separatedBy: fromStart).first ?? ""
        let splitLastString = self.components(separatedBy: toEnd).last ?? ""
        var string = self.components(separatedBy: splitFirstString).last
        string = string?.components(separatedBy: splitLastString).first
        return string!
    }
    
    static func fromDictionary(dictionary: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    func toDictionary() -> [String: Any]? {
        let jsonData = self.data(using: .utf8)!
        let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
        return dictionary as? [String: Any]
    }
    
}

// MARK: - HTTP Mothods
public extension String {
    static let get: String = "GET"
    static let post: String = "POST"
}

// MARK: - Convert Date
public extension String {
    /// convert String have format To Date
    /// - Parameter format: String
    /// - Returns: Date?
    func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        return date
    }

    /// convert date to String according string format
    /// - Parameter format: String
    /// - Returns: String?
    func toString(format: String) -> String? {
        guard let date = self.toDate(format: format) else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    /// convert string to date with needFormat then convert this date to string with targetFormat
    /// - Parameters:
    ///   - needFormat: String
    ///   - targetFormat: String
    /// - Returns: String?
    func toString(needFormat: String, targetFormat: String) -> String? {
        guard let date = self.toDate(format: needFormat) else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = targetFormat
        return dateFormatter.string(from: date)
    }
}
