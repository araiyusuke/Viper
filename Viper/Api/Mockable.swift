//
//  Mockable.swift
//  Viper
//
//  Created by 名前なし on 2022/04/26.
//
import Foundation

protocol Mockable: Decodable {
    static func mock(_ file: String?) -> Self
}

extension Mockable {
    static func mock(_ file: String? = nil) -> Self {
        self.mock(file)
    }
}
