//
//  Todo.swift
//  Todo
//
//  Created by Luca D'Alberti on 10/24/16.
//
//

import Foundation
import Vapor
import Fluent

final class Todo: Model {
    
    var id: Node?
    var content: String
    var imageUrlString: String?
    var userId: Node?
    var exists: Bool = false
    
    // Only for me, for generating random content
    init(content: String, imageUrlString: String?) {
        self.id = UUID().uuidString.makeNode()
        self.content = content
        self.imageUrlString = imageUrlString
        self.userId = 1
    }
    
    // This function is called when vapor has to generate the Todo object
    // (from a query result and from a JSON request)
    init(node: Node, in context: Context) throws {
        if let userId = node["user_id"]?.int {
            self.userId = try userId.makeNode()
        }
        if let content = node["content"]?.string {
            self.content = content
            self.imageUrlString = node["img_url"]?.string
        } else {
            throw Abort.custom(status: .badRequest, message: "content parameter is missing")
        }
    }

    func makeJSON() throws -> JSON {
        let node = try Node(
            node: [
                "id": self.id,
                "content": self.content,
                "img_url": self.imageUrlString
            ]
        )
        
        return JSON(node)
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(
            node: [
                "id": self.id,
                "content": self.content,
                "img_url": self.imageUrlString,
                "user_id": self.userId
            ]
        )
    }

    static func `for`(_ userId: Int, todoId: Int? = nil) throws -> [Todo] {
        var todoQuery = try Todo.query().filter(TodoTable.userId.tableIdentifier, userId)
        
        if let todoId = todoId {
            todoQuery = try todoQuery.filter(TodoTable.id.tableIdentifier, todoId)
        }
        
        return try todoQuery.run()
    }
}

extension Todo {
    
    static func prepare(_ database: Database) throws {
        try database.create("todos") { todos in
            todos.id()
            todos.string(TodoTable.content.tableIdentifier)
            todos.string(TodoTable.imgUrl.tableIdentifier, length: nil, optional: true)
            todos.string(TodoTable.userId.tableIdentifier)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("todos")
    }
}

fileprivate enum TodoTable: String {
    
    case id, content
    case imgUrl = "img_url"
    case userId = "user_id"
    
    var tableIdentifier: String { return rawValue }
}
