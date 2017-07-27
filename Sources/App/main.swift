import Vapor
import HTTP
import VaporPostgreSQL
import HTTPRouting
import Routing

// Creating droplet
let drop = Droplet()

// Creating routes
private let _usersRoute = UsersRouter()
private let _todosRoute = TodosRouter()

// Adding PostgreSQL provider
try! drop.addProvider(VaporPostgreSQL.Provider.self)

// Preparing Todo and User tables in PostgreSQL
drop.preparations.append(Todo.self)
drop.preparations.append(User.self)

// Adding logger middleware
drop.middleware.append(LoggerMiddleware())

// Registering todos group
// UserMiddleware is checking if the user is logged in before getting to the specific
// route
drop.group(UserMiddleware()) { group in
    group.post("todos", handler: _todosRoute.create)
    group.get("todos", handler: _todosRoute.getAll)
    group.get("todos", Int.self, handler: _todosRoute.getSpecific)
}

// Register users group
drop.group("users") { users in
    // The bodyValidator checks if the expected body satisfies the body we expect
    // And passes directly the expected object to the handler
    users.post(using: BodyValidator<UserRegistrationBody>(), handler: _usersRoute.register)
    users.post("login", using: BodyValidator<UserLoginBody>(), handler: _usersRoute.login)
}

drop.run()

