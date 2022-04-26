//
//  UsersAPI.swift
//  Viper
//
//  Created by 名前なし on 2022/04/26.
//

import Foundation
import Combine



enum UsersAPI {
    
    struct Response: Mockable {
        
        let users: [User]
        
        init(from decoder: Decoder) throws {
            var users: [User] = []
            var unkeyedContainer = try decoder.unkeyedContainer()
            while !unkeyedContainer.isAtEnd {
                let user = try unkeyedContainer.decode(User.self)
                users.append(user)
            }
            self.users = users
        }
    }
    
    private static let agent = AgentFactory.create()

    static func fetch() -> AnyPublisher<Response, Error> {
        return agent.run(
            API
                .Users
                .Fetch
                .request()
        )
    }
    
    static func addUser() -> AnyPublisher<Response, Error> {
        return agent.run(
            API
                .Users
                .Fetch
                .request()
        )
    }
}
