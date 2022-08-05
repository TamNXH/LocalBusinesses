//
//  JSONDecoderExtension.swift
//  LocalBusinesses
//
//  Created by TamNXH on 03/08/2022.
//

import Foundation

extension JSONDecoder {

    func decodeObjectFrom<T: Decodable>(data: Data?, objectType: T.Type) -> T? {
        
        guard let data = data else {
            return nil
        }
        
        do {
            let object = try self.decode(objectType, from: data)
            return object
        } catch {
            return nil
        }
        
    }
    
    func decodeJsonP<T>(_ type: T.Type, from jsonString: String) throws
        -> T where T: Decodable {
        let json = jsonString.convertJSONPToJSON(fromStart: "{", toEnd: "}")
        let data = json.data(using: String.Encoding.utf8) ?? Data()
        let example = try self.decode(type, from: data)
        return example
    }
    
    func decodeJsonP<T>(_ type: T.Type, from dictionary: [String: Any]?)
        -> T? where T: Decodable {
            if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary as Any, options: []) {
            let decoded = try? JSONDecoder().decode(T.self, from: jsonData)
            return decoded
        }
        return nil
    }
    
    func decodeJson<T: Decodable>(type: T.Type, json: String) throws -> T {
        let data = json.data(using: String.Encoding.utf8) ?? Data()
        return try self.decode(type, from: data)
    }
    
    func setDataDictionary(notification: [String: Any]) -> [String: Any] {
        var dictionary: [String: Any] = notification
        dictionary.removeValue(forKey: "aps")
        dictionary["receiver"] = [""]
        dictionary["sendTopicExceptUsers"] = [""]
        dictionary["isRead"] = [""]
        return dictionary
    }
}
