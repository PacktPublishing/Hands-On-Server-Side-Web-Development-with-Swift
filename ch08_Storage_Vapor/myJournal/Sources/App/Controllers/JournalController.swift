//
//  JournalController.swift
//  App
//
//  Created by Angus yeung on 7/4/18.
//

import Vapor

final class JournalController {

    var entries : Array<Entry> = Array()
    
    //: Get total number of entries
    func total() -> Int {
        return entries.count
    }
    //: Create a new journal entry
    func create(_ entry: Entry) -> Entry? {
        entries.append(entry)
        return entries.last
    }
    //: Read a journal entry
    func read(index: Int) -> Entry? {
        if index < entries.count {
            return entries[index]
        } else {
            return nil
        }
    }
    //: Read all journal entries
    func readAll() -> [Entry] {
        return entries
    }
    //: Update the journal entry
    func update(index: Int, entry: Entry) -> Entry? {
        if index < entries.count {
            entries[index] = entry
            return entry
        } else {
            return nil
        }
    }
    //: Delete a journal entry
    func delete(index: Int) -> Entry? {
        if index < entries.count {
            return entries.remove(at: index)
        } else {
            return nil
        }
    }
}
