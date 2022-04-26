//
//  Token.swift
//  Viper
//
//  Created by 名前なし on 2022/04/26.
//

import Foundation
import Combine
import SwiftUI

let __deviceToken: String = "deviceToken"
let __deviceLoginId: String = "deviceLoginId"

struct APIToken: Codable {
//    static let deviceTokenStub: DeviceToken = try .init(plainText: "1|c0XkzFmabMVCSl3XUghB9cgrvWUQSDhZtmH6K1T1")
//    static let memberTokenStub: MemberToken = .init(plainText: "224|anJdwAXi5XbxmJQpK8cQug12hhnzzHSQtBgQZC2h")
}

class Device : ObservableObject {

    @AppStorage(__deviceToken) var tokenPlainText: String?
    @AppStorage(__deviceLoginId) var loginId: String?

    var token: DeviceToken {
        DeviceToken(plainText: tokenPlainText)
    }

    func logout() {
        tokenPlainText = nil
        loginId = nil
    }
}

enum TokenError: Error {
    case Nil
}

protocol Token: Codable {
    init()
    var plainText: String? { get set}
}

extension Token {
    init(plainText: String?) throws {
        if plainText == nil {
            throw TokenError.Nil
        }
        self.init()
        self.plainText = plainText
    }
}

struct DeviceToken: Token {
    var plainText: String?
}

struct MemberToken: Token, CustomStringConvertible {
    
    var plainText: String?
    
    var description: String {
        return """
        \(plainText ?? "nil")
        """
    }
}
