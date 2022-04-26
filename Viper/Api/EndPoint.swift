//
//  EndPoint.swift
//  Viper
//
//  Created by 名前なし on 2022/04/26.
//

import Foundation

struct EndPoint {

    let url: URL
    
    init(url: String) {
        self.url = URL(string: url)!
    }
}
