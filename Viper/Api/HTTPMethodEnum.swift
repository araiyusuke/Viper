//
//  HTTPMethodEnum.swift
//  Viper
//
//  Created by 名前なし on 2022/04/26.
//

import Foundation

enum HTTPRequestMethod: String {
    
    case get, post, put, delete
   
    var description: String {
        switch(self) {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}
