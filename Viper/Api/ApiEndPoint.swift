//
//  ApiEndPoint.swift
//  Viper
//
//  Created by 名前なし on 2022/04/26.
//
import Foundation

struct API {

    static let PROTOCOL = URL(string: Configuration.shared.API_HTTP_PROTOCOL)!
    static let HOST = URL(string: Configuration.shared.API_HOST)!
    static let MEMBER = "users"
    static let USER_END_POINT = "\(API.PROTOCOL)\(API.HOST)\(MEMBER)"

    struct Users {

        struct Fetch: RequestParameter {

            static let endPoint = EndPoint(url:"\(API.USER_END_POINT)/")

            static func request() -> URLRequest {
                return URLRequest.create(endPoint, method: .get)
            }
        }
        
        struct Create: RequestParameter {

            static let endPoint = EndPoint(url:"\(API.USER_END_POINT)/")

            static func request() -> URLRequest {
                return URLRequest.create(endPoint, method: .get)
            }
        }
    }
}
