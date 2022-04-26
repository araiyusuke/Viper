//
//  JsonEncodeSnakeCase.swift
//  Viper
//
//  Created by 名前なし on 2022/04/26.
//

import Foundation

func jsonDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}
