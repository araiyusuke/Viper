//
//  Configuration.swift
//  Viper
//
//  Created by ććăȘă on 2022/04/26.
//

import Foundation

struct Configuration {
    
    static let shared = Configuration()
    
    let API_HOST: String
    let API_HTTP_PROTOCOL: String
    
    private init() {
        API_HOST = "localhost:3000/"
        API_HTTP_PROTOCOL = "http://"
    }
}
