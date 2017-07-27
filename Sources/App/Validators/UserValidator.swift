//
//  UserValidator.swift
//  Todo
//
//  Created by Luca D'Alberti on 2/24/17.
//
//

import Foundation
import Vapor
import HTTP

struct UserRegistrationBody: RequestInitializable {
    
    let name: Valid<Name>
    let username: Valid<Name>
    let password: Valid<Password>
    
    init(request: Request) throws {
        name = try (request.data["name"] ?? "").validated()
        username = try (request.data["username"] ?? "").validated()
        password = try (request.data["password"] ?? "").validated()
    }
}

struct UserLoginBody: RequestInitializable {
    
    let username: Valid<Name>
    let password: Valid<Password>
    
    init(request: Request) throws {
        username = try (request.data["username"] ?? "").validated()
        password = try (request.data["password"] ?? "").validated()
    }
}

class Name: ValidationSuite {
    
    static func validate(input value: String) throws {
        let evaluation = OnlyAlphanumeric.self
            && Count.min(5)
            && Count.max(32)
        
        try evaluation.validate(input: value)
    }
}

class Password: ValidationSuite {
    
    static func validate(input value: String) throws {
        let evaluation = OnlyAlphanumeric.self && Count.min(8) && Count.max(32)
        
        try evaluation.validate(input: value)
    }
}
