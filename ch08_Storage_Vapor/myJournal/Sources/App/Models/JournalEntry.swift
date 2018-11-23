//
//  Item.swift
//  App
//
//  Created by Angus yeung on 8/3/18.
//

//import FluentSQLite
import FluentPostgreSQL
import Vapor

final class JournalEntry: PostgreSQLModel {
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