//
//  Entry.swift
//  App
//
//  Created by Angus yeung on 7/4/18.
//

import Vapor

struct Entry: Content, Parameter {
    
    var id: String
    var title: String?
    var content: String?
    
    init(id: String, title: String? = nil, content: String? = nil) {
        self.id = id
        self.title = title
        self.content = content
    }
    
    // conforming to the Parameter protocol
    static func resolveParameter(_ parameter: String, on container: Container) throws -> Entry {
        return Entry(id: parameter)
    }
}
