import FluentPostgreSQL
import Vapor
import Authentication

final class Admin: PostgreSQLModel {
    var id: Int?
    var name: String
    var login: String
    var password: String // password is hashed
    
    init(id: Int? = nil, name: String, login: String, password: String) {
        self.id = id
        self.name = name
        self.login = login
        self.password = password
    }
}

extension Admin: PasswordAuthenticatable {
    static var usernameKey: WritableKeyPath<Admin, String> {
        return \.login
    }
    
    static var passwordKey: WritableKeyPath<Admin, String> {
        return \.password
    }
}
extension Admin: SessionAuthenticatable { }
extension Admin: Migration { }
extension Admin: Content { }
extension Admin: Parameter { }
