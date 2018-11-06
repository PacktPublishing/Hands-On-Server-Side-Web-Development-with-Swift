//
//  JournalEntry.swift
//  myJournal
//
//  Created by Angus yeung on 10/31/18.
//  Copyright © 2018 Server Side Swift. All rights reserved.
//

import Foundation

final class JournalEntry: NSObject, Codable {
    let id: Int?
    var title: String?
    var content: String?
    
    public init(title: String?, content: String?) {
        self.id = nil
        self.title = title
        self.content = content
    }
}
