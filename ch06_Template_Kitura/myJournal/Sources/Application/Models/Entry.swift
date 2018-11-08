//
//  Entry.swift
//  Application
//
//  Created by Angus yeung on 7/8/18.
//

import Foundation

struct Entry: Codable {
    
    var id: String
    var title: String?
    var content: String?
    
    init(id: String, title: String? = nil, content: String? = nil) {
        self.id = id
        self.title = title
        self.content = content
    }
}
