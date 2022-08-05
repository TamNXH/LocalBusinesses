//
//  HTTPRequest.swift
//  LocalBusinesses
//
//  Created by TamNXH on 03/08/2022.
//

import Foundation

extension URLRequest {
    mutating func setHeaderRequest() {
        self.setValue("Bearer qs4uxmxX53gKlLa5KU1jYr2t9T7F97PgK51lsMEROktQYiZ6ZIgpL3bcxb_Z6egN2JfkCOlLiU5PXrlzbg4G4oqk8oUddJ1-H92W-TWMgdOYQAAJaSDGmhoD6njqYnYx", forHTTPHeaderField: "Authorization")
    }
}
