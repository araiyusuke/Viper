//
//  RequestParameter.swift
//  Viper
//
//  Created by ććăȘă on 2022/04/26.
//

import Foundation

protocol RequestParameter: Codable {}

extension RequestParameter {
    var data: Data! {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try? encoder.encode(self)
    }
}
