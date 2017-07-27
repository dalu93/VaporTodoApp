//
//  LoggerMiddleware.swift
//
//  Created by Luca D'Alberti on 1/19/17.

import Vapor
import HTTP
import Foundation

/// Describes how a logger used in the middleware should be built.
protocol Logger {
    
    func print(_ message: String)
    func print(_ stringConvertible: CustomStringConvertible)
}

/// This logger uses the `Swift.print()` function to print the messages.
struct BasicLogger: Logger {
    
    func print(_ message: String) {
        Swift.print(message)
    }
    
    func print(_ stringConvertible: CustomStringConvertible) {
        Swift.print(stringConvertible.description)
    }
}

/// The logger automatically prints every incoming and outgoing response, tracking the response code,
/// the error and the request duration in ms.
///
/// It can easily customized by providing your own `Logger` instance. See the `Logger` protocol for more info.
final class LoggerMiddleware: Middleware {
    
    /// The logger instance to use.
    ///
    /// Provide your own custom instance by conforming to `Logger` protocol.
    let logger: Logger
    
    init(_ logger: Logger = BasicLogger()) {
        self.logger = logger
    }
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        // Prints the incoming request details.
        logger.print("--> \(request.method) - \(request.uri)")
        
        // Saving the starting date.
        let startDate = Date()
        do {
            // Trying to get the next responder's response.
            let response = try next.respond(to: request)
            
            // Getting the request's end date.
            let endDate = Date()
            
            // Calculating the difference in milliseconds.
            let differenceInMs: Int = Int((endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970) * 1000)
            
            // Logging the response details
            logger.print("<-- \(response.status.statusCode) \(request.method) \(differenceInMs)ms - \(request.uri)")
            return response
        } catch (let exception) {
            // In case it failed
            // Logging the detail of the failure
            logger.print("<-- FAILED \(request.method) - \(request.uri): \(exception)")
            
            // Propagating the exception
            throw exception
        }
    }
}
