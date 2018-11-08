//
//  Item.swift
//  App
//
//  Created by Angus yeung on 8/3/18.
//

//import FluentSQLite
import FluentPostgreSQL
import Vapor

final class JournalEntry: PostgreSQLModel {//SQLiteModel {
    var id: Int?
    var title: String
    var content: String
    
    init(id: Int? = nil, title: String, content: String) {
        self.id = id
        self.title = title
        self.content = content
    }
}

extension JournalEntry: Migration { }
extension JournalEntry: Content { }
extension JournalEntry: Parameter { }


/*

final class JournalEntry: Codable {
//    typealias Database = SQLiteDatabase
//    typealias ID = String
//    static let idKey: IDKey = \.id
    
    var id: String?
    var title: String
    var content: String
    
    init(title: String,
         content: String) {
        self.title = title
        self.content = content
    }
}

extension JournalEntry: SQLiteStringModel { }
extension JournalEntry: Migration { }
extension JournalEntry: Content { }
extension JournalEntry: Parameter { }
*/
