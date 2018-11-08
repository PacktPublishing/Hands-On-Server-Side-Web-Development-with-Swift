import Foundation
import FluentPostgreSQL
import Vapor
import Authentication

final class AdminToken: PostgreSQLModel {
    var id: Int?
    var token: String
    var adminID: Admin.ID
    
    init(token: String, adminID: Admin.ID) {
        self.token = token
        self.adminID = adminID
    }
    
    static func createToken(forAdmin admin: Admin) throws -> AdminToken {
        let token = try AdminToken(token: generateToken(withLength: 60),
                                   adminID: admin.requireID())
        return token
    }
    
    // credit: https://stackoverflow.com/questions/26845307/generate-random-alphanumeric-string-in-swift
    static func generateToken(withLength length: Int) -> String {
        let charSet = "$!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var myString = ""
        for _ in 0..<length {
            let randomNumber = Int(arc4random_uniform(UInt32(charSet.count)))
            let index = charSet.index(charSet.startIndex, offsetBy: randomNumber)
            let myChar = charSet[index]
            myString += String(myChar)
        }
        return myString
    }
}

extension AdminToken {
    var admin : Parent<AdminToken, Admin> {
        return parent(\.adminID)
    }
}



extension AdminToken: Content { }

extension AdminToken: Migration {}

extension AdminToken {
    static func generateToken(for admin: Admin) throws -> AdminToken {
        let rand = try CryptoRandom().generateData(count: 16)
        return try AdminToken(token: rand.base64EncodedString(), adminID: admin.requireID())
    }
}

extension AdminToken: BearerAuthenticatable {
    static let tokenKey: TokenKey = \AdminToken.token
}
/*
extension AdminToken: Authentication.Token {
    static let adminIDKey: AdminIDKey = \Token.adminID
    typealias AdminType = Admin
}
 */

