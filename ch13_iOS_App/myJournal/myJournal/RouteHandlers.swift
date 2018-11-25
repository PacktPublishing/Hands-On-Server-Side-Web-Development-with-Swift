//
//  RouteHandlers.swift
//  myJournal
//
//  Created by Angus yeung on 10/31/18.
//  Copyright © 2018 Server Side Swift. All rights reserved.
//

import UIKit


extension MainScreenViewController {
    
    // Read all entries
    func getAll() {
        guard let journalUrl = URL(string: apiURL + "/journal") else { return }
        URLSession.shared.dataTask(with: journalUrl) { (data, response, error) in
            guard let jsonData = data else { return }
            print("INFO: Getting JSON data...")
            do {
                // take advantage of Codable for JSON decode
                let entries = try JSONDecoder().decode([JournalEntry].self, from: jsonData)
                 print("INFO: Decoding JSON data...")
                // append each entry to the local store
                self.journalEntries.append(contentsOf: entries)
                // signal the UI thread to reload table data
                DispatchQueue.main.async { self.tableView.reloadData() }
            } catch {
                print("Error", error)
            }
        }.resume()
    }
    
    // Read the entry with Id
    func getEntry(Id: Int) {
    }
    
    // Create a new entry
    func newEntry(entry: JournalEntry) {
        
        print("INFO: Receiving newly created entry: \(entry)")
        
        // prepare JSON data to upload
        guard let jsonData = try? JSONEncoder().encode(entry) else { return }
        print("INFO: Packing int JSON object: \(jsonData)")
        
        // configure URL request
        let journalUrl = URL(string: apiURL + "/admin")!
        var request = URLRequest(url: journalUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("INFO: Posting to Server: \(request)")
        
        // Start an URLSession Task
        URLSession.shared.uploadTask(with: request, from: jsonData) { (data, response, error) in
            if let error = error {
                print("Error", error)
                return
            }
        }.resume()
    }
    
    // Edit an existing entry
    func editEntry(entry: JournalEntry) {
        print("INFO: Receiving modified entry: \(entry)")
        
        // prepare JSON data to upload
        guard let jsonData = try? JSONEncoder().encode(entry) else { return }
        print("INFO: Packing int JSON object: \(jsonData)")
        
        // configure URL request
        if let id = entry.id {
            let idString : String = "/admin/\(id)"
            let journalUrl = URL(string: apiURL + idString)!
            var request = URLRequest(url: journalUrl)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            print("INFO: Putting to Server: \(request)")
            
            // Start an URLSession Task
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data, response, error) in
                if let error = error {
                    print("Error", error)
                    return
                }
                }.resume()
        }
    }
    
    // Remove an existing entry
    func removeEntry(entry: JournalEntry) {
        print("INFO: Receiving the entry to be deleted: \(entry)")
        
        // prepare JSON data to upload
        guard let jsonData = try? JSONEncoder().encode(entry) else { return }
        print("INFO: Packing int JSON object: \(jsonData)")
        
        // configure URL request
        if let id = entry.id {
            let idString : String = "/admin/\(id)"
            let journalUrl = URL(string: apiURL + idString)!
            var request = URLRequest(url: journalUrl)
            request.httpMethod = "DELETE"
            print("INFO: Requesting Server to delete: \(request)")
            
            // Start an URLSession Task
            URLSession.shared.uploadTask(with: request, from: jsonData) { (data, response, error) in
                if let error = error {
                    print("Error", error)
                    return
                }
                }.resume()
        }
    }
}
