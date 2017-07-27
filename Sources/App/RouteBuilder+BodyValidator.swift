//
//  RouteBuilder+BodyValidator.swift
//  Todo
//
//  Created by D'Alberti, Luca on 7/27/17.
//
//

import Vapor
import HTTP
import HTTPRouting
import Routing

// See https://github.com/vapor/vapor/issues/881
public extension Routing.RouteBuilder where Value == HTTP.Responder {
    
    public func post<BodyType: RequestInitializable>(_ p0: String = "", using bodyChecker: BodyValidator<BodyType> = BodyValidator<BodyType>(), handler: @escaping (BodyType, Request) throws -> ResponseRepresentable) {
        self.add(.post, p0) { request in
            // execute body validator check
            let newRequest = try bodyChecker.validate(request)
            // check the validationBody
            guard let validatedBody = newRequest.validatedBody as? BodyType else {
                throw BodyValidationError.invalidBody
            }
            
            // call the handler
            return try handler(validatedBody, newRequest).makeResponse()
            
        }
    }
}
