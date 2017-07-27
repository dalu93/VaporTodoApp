//
//  TokenSerializer.swift
//  Todo
//
//  Created by Luca D'Alberti on 1/30/17.
//
//

import Foundation
import JWT

private let jwtSecret = "testtest"

final class TokenSerializer {
    
    func decode(_ token: String) throws -> Payload {
        return try JWT.decode(token, algorithm: .hs256(jwtSecret.data(using: .utf8)!))
    }
    
    func encode(_ payload: Payload) -> String {
        return JWT.encode(payload, algorithm: .hs256(jwtSecret.data(using: .utf8)!))
    }
}
