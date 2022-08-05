//
//  NetworkProtocols.swift
//  LocalBusinesses
//
//  Created by TamNXH on 03/08/2022.
//

import Foundation
import Combine

public protocol NetworkServicesProtocol: AnyObject {
    func request(info: RequestInfo) -> AnyPublisher<Data, NetworkError>
}
