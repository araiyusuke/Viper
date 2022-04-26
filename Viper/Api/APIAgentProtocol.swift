//
//  APIAgentProtocol.swift
//  Viper
//
//  Created by 名前なし on 2022/04/26.
//

import Foundation
import Combine

protocol APIAgentProtocol {
    func run<T: Mockable>(_ request: URLRequest, mockFile: String?, statusCd: Int?) -> AnyPublisher<T, Error>
}

extension APIAgentProtocol {
    func run<T: Mockable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        self.run(request, mockFile: nil, statusCd: nil)
    }
}
