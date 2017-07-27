//
//  UserController.swift
//  Todo
//
//  Created by Luca D'Alberti on 12/7/16.
//
//

import Vapor
import HTTP

final class UserController {
    
    private let _tokenSerializer = TokenSerializer()
    
    func registerUserBy(using body: UserRegistrationBody) throws -> User {
        let usersWithSameUsername = try User.get(with: body.username.value)
        guard usersWithSameUsername.count == 0 else {
            throw Abort.notFound
        }
        
        // var is needed here because .save() is a mutating func
        var user = User(name: body.name.value, password: body.password.value, username: body.username.value)
        try user.save()
        
        return user
    }
    
    func login(using body: UserLoginBody) throws -> String {
        let user = try User.fromLoginWith(body.username.value, and: body.password.value)
        let token = _tokenSerializer.encode([
            "id": user.id!.int!,
            "username": user.username
            ])
        
        return token
    }
}

