//
//  JournalRoutes.swift
//  Application
//
//  Created by Angus yeung on 7/8/18.
//

import Foundation
import Kitura

struct JournalRoutes {

    let journal = JournalController()

    func getTotal() -> Int {
        return journal.total()
    }

    func newEntry(entry: Entry, completion: (Entry?, RequestError?) -> Void ) {
        let newID = UUID().uuidString
        if let result = journal.create(Entry(id: newID,
                                             title: entry.title,
                                             content: entry.content)) {
            print("Created: \(result)")
            completion(result, nil)
        } else {
            completion(Entry(id: "-1"), nil)
        }
    }
    
    func editEntry(id: Int, new: Entry, completion: (Entry?, RequestError?) -> Void ) -> Void {
        let newID = UUID().uuidString
        if let result = journal.update(index: id,
                                       entry: Entry(id: newID,
                                                    title: new.title,
                                                    content: new.content)) {
            print("Updated: \(result)")
            completion(result, nil)
        } else {
            completion(nil, .notFound)
        }
    }
    
    func getEntry(index: Int, completion: (Entry?, RequestError?) -> Void ) {
        if let entry = journal.read(index: index) {
            completion(entry, nil)
            return
        }
        completion(nil, .notFound)
        return
    }
    
    func removeEntry(id: Int, completion: (RequestError?) -> Void ) -> Void {
        if let result = self.journal.delete(index: id) {
            print("Deleted: \(result)")
            completion(nil)
            return
        }
        completion(.notFound)
    }
}
