//
//  User.swift
//  Todo
//
//  Created by Luca D'Alberti on 12/7/16.
//
//

import Foundation
import Vapor

final class User: Model {
    
    static let tableName: String = "users"
    
    var id: Node?
    var name: String
    var username: String
    
    var accessToken: String?
    
    var exists: Bool = false
    
    fileprivate var _password: String
    
    init(name: String, password: String, username: String) {
        self.name = name
        self._password = password
        self.username = username
    }
    
    init(node: Node, in context: Context) throws {
        self.name = try node.extract("name")
        self.username = try node.extract("username")
        self._password = try node.extract("password")
    }
    
    // Returned when creating JSON (we don't want to include password)
    func makeJSON() throws -> JSON {
        let node = try Node(
            node: [
                "id": self.id,
                "name": self.name,
                "username": self.username
            ]
        )
        
        return JSON(node)
    }
    
    // Returned when creating a Node (here the password is needed)
    func makeNode(context: Context) throws -> Node {
        return try Node(
            node: [
                "id": self.id,
                "name": self.name,
                "username": self.username,
                "password" : self._password
            ]
        )
    }
}

extension User {
    
    static func get(with username: String) throws -> [User] {
        return try User.query().filter(UserTable.username.tableIdentifier, username).run()
    }
    
    static func fromLoginWith(_ username: String, and password: String) throws -> User {
        let foundUsers = try User.query()
            .filter(UserTable.username.tableIdentifier, username)
            .filter(UserTable.password.tableIdentifier, password)
            .run()
        
        guard foundUsers.count > 0 && foundUsers.count <= 1 else {
            throw Abort.serverError
        }
        
        return foundUsers.first!
    }
}

extension User {
    
    static func prepare(_ database: Database) throws {
        try database.create(User.tableName) { users in
            users.id()
            users.string(UserTable.name.tableIdentifier)
            users.string(UserTable.username.tableIdentifier)
            users.string(UserTable.password.tableIdentifier)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(User.tableName)
    }
}

fileprivate enum UserTable: String {
    
    case id, name, username, password
    
    var tableIdentifier: String { return rawValue }
}
