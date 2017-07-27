//
//  UsersRouter.swift
//  Todo
//
//  Created by Luca D'Alberti on 1/31/17.
//
//

import Vapor
import HTTP

final class UsersRouter {
    
    fileprivate let _userController = UserController()
    
    func login(using body: UserLoginBody, and request: Request) throws -> ResponseRepresentable {
        let token = try _userController.login(using: body)
        return try JSON(node: ["access_token": token])
    }
    
    func register(_ user: UserRegistrationBody, and request: Request) throws -> ResponseRepresentable {
        return try _userController.registerUserBy(using: user)
    }
}
