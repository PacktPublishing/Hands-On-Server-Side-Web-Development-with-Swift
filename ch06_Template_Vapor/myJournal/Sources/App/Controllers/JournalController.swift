//
//  JournalController.swift
//  App
//
//  Created by Angus yeung on 7/4/18.
//

import Vapor

final class JournalController {
    
    var entries : Array<Entry> = Array()    // [1]
    
    //: Get total number of entries
    func total() -> Int {                   // [2]
        return entries.count
    }
    //: Create a new journal entry
    func create(_ entry: Entry) -> Entry? { // [3]
        entries.append(entry)
        return entries.last
    }
    //: Read a journal entry
    func read(index: Int) -> Entry? {       // [5]
        if let entry = entries.get(index: index) {
            return entry
        } 
        return nil
    }
    //: Read all journal entries
    func readAll() -> [Entry] {
        return entries
    }
    //: Update the journal entry
    func update(index: Int, entry: Entry) -> Entry? {   // [6]
        if let entry = entries.get(index: index) {
            entries[index] = entry
            return entry
        } 
        return nil
    }
    //: Delete a journal entry
    func delete(index: Int) -> Entry? {     // [7]
        if let _ = entries.get(index: index) {
            return entries.remove(at: index)
        } 
        return nil
    }
}

extension Array {
    func get(index: Int) -> Element? {      // [4]
        if index >= 0 && index < count {
            return self[index]
        }
        return nil
    }
}


