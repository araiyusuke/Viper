//
//  StatusCode.swift
//  Viper
//
//  Created by 名前なし on 2022/04/26.
//

import Foundation

enum StatusCode: Error {
    static let HTTP_SUCCESS: Int = 200
    static let HTTP_UNAUTHORIZED_401: Int = 401
    static let HTTP_CLIENT_ERROR_RANGE = 400...499
    static let HTTP_SERVER_ERROR_RANGE = 500...599
    static let HTTP_UNPROCESSABLE_ENTITY_422 = 422
    static let HTTP_NOT_FOUND_AND_NOT_ALLOWED = 404...405
    // Laravel Throttle
    static let HTTP_TOO_MANY_REQUESTS_429 = 429

    case server(Int)
    case sessionFailed(error: Error)
    case decode(Error)
    case noResponse
    case unknown(Error)

}
