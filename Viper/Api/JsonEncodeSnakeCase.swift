//
//  JsonEncodeSnakeCase.swift
//  Viper
//
//  Created by ććăȘă on 2022/04/26.
//

import Foundation

func jsonDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}
