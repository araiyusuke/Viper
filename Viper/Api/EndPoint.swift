//
//  EndPoint.swift
//  Viper
//
//  Created by ććăȘă on 2022/04/26.
//

import Foundation

struct EndPoint {

    let url: URL
    
    init(url: String) {
        self.url = URL(string: url)!
    }
}
