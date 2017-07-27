//
//  TodosRouter.swift
//  Todo
//
//  Created by Luca D'Alberti on 1/31/17.
//
//

import Vapor
import HTTP

final class TodosRouter {
    
    fileprivate let _todoController = TodoController()
    
    func create(using request: Request) throws -> ResponseRepresentable {
        return try _todoController.createOne(using: request)
    }
    
    func getAll(using request: Request) throws -> ResponseRepresentable {
        let todos = try _todoController.getTodos(using: request)
        return JSONArray(todos, key: "todos")
    }
    
    func getSpecific(using request: Request, with todoId: Int) throws -> ResponseRepresentable {
        return try _todoController.getSpecific(using: request, with: todoId)
    }
}

// See https://github.com/vapor/vapor/issues/810
struct JSONArray<Element: JSONRepresentable>: ResponseRepresentable {
    let elements: [Element]
    let key: String?
    
    init(_ elements: [Element], key: String? = nil) {
        self.elements = elements
        self.key = key
    }
    
    func makeResponse() throws -> Response {
        let elementsJSON = try elements.map { try $0.makeJSON() }
        if let key = key {
            let node = try Node(node: [
                key: elementsJSON.makeNode()
            ])
            
            return try JSON(node).makeResponse()
        } else {
            return try JSON(elementsJSON.makeNode()).makeResponse()
        }
    }
}

