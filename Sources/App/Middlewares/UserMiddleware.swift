//
//  UserMiddleware.swift
//  Todo
//
//  Created by Luca D'Alberti on 1/19/17.
//
//

import Vapor
import HTTP
import JWT

fileprivate let tokenSerializer = TokenSerializer()

extension Request {
    
    var accessToken: String? {
        return headers["accessToken"]?.string ?? data["access_token"]?.string
    }
    
    func getUserId() throws -> Int {
        guard let token = accessToken else {
            throw Abort.custom(status: .unauthorized, message: "Unauthorized")
        }
        
        let userInfo = try tokenSerializer.decode(token)
        guard let userId = userInfo["id"] as? Int else {
            throw Abort.badRequest
        }
        
        return userId
    }
}

final class UserMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        guard request.accessToken != nil else {
            throw Abort.custom(status: .unauthorized, message: "Unauthorized")
        }
        
        let response = try next.respond(to: request)
        return response
    }
}

