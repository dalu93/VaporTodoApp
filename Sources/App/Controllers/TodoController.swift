//
//  TodoController.swift
//  Todo
//
//  Created by Luca D'Alberti on 11/4/16.
//
//

import Vapor
import HTTP

final class TodoController {
    
    func getTodos(for userId: Int) throws -> [Todo] {
        return try Todo.for(userId)
    }
    
    func getTodos(using request: Request) throws -> [Todo] {
        let userId = try request.getUserId()
        
        return try getTodos(for: userId)
    }
    
    func create(with json: JSON, for userId: Int) throws -> Todo {
        var todo = try Todo(node: json)
        todo.userId = try userId.makeNode()
        
        try todo.save()
        return todo
    }
    
    func createOne(using request: Request) throws -> Todo {
        let userId = try request.getUserId()
        
        guard let json = request.json else {
            throw Abort.badRequest
        }
        
        return try create(with: json, for: userId)
    }
    
    func getSpecific(using request: Request, with id: Int) throws -> Todo {
        let userId = try request.getUserId()
        
        let foundTodo = try Todo.for(userId, todoId: id)
        guard foundTodo.count > 0 else {
            throw Abort.notFound
        }
        
        guard foundTodo.count == 1 else {
            throw Abort.serverError
        }
        
        return foundTodo.first!
    }
}
