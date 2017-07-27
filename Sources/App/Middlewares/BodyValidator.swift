//
//  BodyValidator.swift
//  Todo
//
//  Created by Luca D'Alberti on 3/9/17.
//
//

import Vapor
import HTTP

public enum BodyValidationError: Error {
    case invalidBody
}

public class BodyValidator<BodyType: RequestInitializable> {
    
    public func validate(_ request: Request) throws -> Request {
        let validatedBody = try BodyType(request: request)
        request.validatedBody = validatedBody
        
        return request
    }
}

public extension Request {
    
    var validatedBody: RequestInitializable? {
        get {
            return storage["validatedBody"] as? RequestInitializable
        }
        
        set {
            storage["validatedBody"] = newValue
        }
    }
}
