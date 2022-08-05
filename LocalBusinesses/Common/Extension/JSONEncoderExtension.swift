//
//  JSONEncoderExtension.swift
//  LocalBusinesses
//
//  Created by TamNXH on 03/08/2022.
//

import UIKit

extension JSONEncoder {
    
    func encodeDto<T: Encodable>(dto: T) throws -> String {
        let data = try self.encode(dto)
        return String(data: data, encoding: String.Encoding.utf8) ?? "" //String.empty
    }
    
    func toJsonStringFrom<T: Encodable>(_ object: T) -> String? {
        
        do {
            let jsonData = try self.encode(object)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            return nil
        }
        
    }
    
    func toArrayFrom<T: Encodable>(_ object: [T]) -> [[String: Any]]? {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(object)
            let jsonString = String(data: jsonData, encoding: .utf8)
//            Logger.LogDebug(type: .info, message: "JSON String : " + jsonString!)
            let data = Data(jsonString!.utf8)
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                return json
            }
        } catch {
        }
        return nil
    }
    
    func toDictionaryFrom<T: Encodable>(_ object: T) -> [String: Any]? {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(object)
            let jsonString = String(data: jsonData, encoding: .utf8)
//            Logger.LogDebug(type: .info, message: "JSON String : " + jsonString!)
            let data = Data(jsonString!.utf8)
            if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                return json
            }
        } catch {
        }
        return nil
    }
}
