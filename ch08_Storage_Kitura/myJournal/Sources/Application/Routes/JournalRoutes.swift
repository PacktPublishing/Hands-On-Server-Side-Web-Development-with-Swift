//
//  JournalRoutes.swift
//  Application
//
//  Created by Angus yeung on 7/16/18.
//

import Foundation
import Kitura
import KituraStencil
import SwiftKueryORM
import SwiftKueryPostgreSQL
import LoggerAPI

func initializeJournalRoutes(app: App) {
  
    let mainPage = "/journal/all"
    
    let title = "My Journal"
    let author = "Angus"

    let poolOptions = ConnectionPoolOptions(initialCapacity: 1,
                                                maxCapacity: 5,
                                                timeout: 10000)
        
    // Set up database connection
    let psqlPool = PostgreSQLConnection.createPool(host: "localhost",
                                               port: 5432,
                                               options: [.databaseName("journalbook")],
                                               poolOptions: poolOptions)
    Database.default = Database(psqlPool)

    do {
        try JournalItem.createTableSync()
    } catch let error {
        Log.error("Failed to create table in database: \(error)")
    }

    app.router.get("/journal/all") { _, response, _ in
        JournalItem.findAll { (result: [(Int, JournalItem)]?, error: RequestError?) in
            guard let items = result else { return }
            var entries: [[String: Any]] = []
            for (index, entry) in items {
              let id = String(index)
              let title : String = entry.title
              let content : String = entry.content
              let map = ["id": id, "title": title, "content": content]
              entries.append(map)
            }
            do {              
                try response.render("main", context: ["title": title,
                                                      "author": author,
                                                      "count": "\(items.count)",
                                                      "entries": entries])
            } catch let error {
                response.send(error.localizedDescription)
            }
        }
    }

    app.router.get("/journal/create") { request, response, next in
        response.headers["Content-Type"] = "text/html; charset=utf-8"
        try response.render("new", context: ["title": title, "author": author])
    }
    
    app.router.post("/journal/new") { request, response, next in
        guard let entry = try? request.read(as: JournalItem.self)
            else { return try response.status(.unprocessableEntity).end() }
        let item = JournalItem(title: entry.title, content: entry.content)
        item.save { item, error in 
        do {
             try response.redirect(mainPage)
            } catch let error {
                response.send(error.localizedDescription)
            } 
        } 
    }
    
    app.router.get("/journal/get/:index?") { request, response, next in
        if let index = request.parameters["index"] {
            if let idx = Int(index) {
              JournalItem.find(id: idx) { result, error in
                guard let item = result else { return }
                let id = String(idx)
                let title : String = item.title
                let content : String = item.content
                let entry = ["id": id, "title": title, "content": content]
                do {
                  try response.render("entry", 
                                      context: ["title": title, 
                                                "author": author, 
                                                "entry": entry])
                } catch let error {
                    response.send(error.localizedDescription)
                }
                
              }

            }
        }
    }
    
    app.router.get("/journal/remove/:index?") { request, response, next in
        if let index = request.parameters["index"] {
            if let idx = Int(index) {
               JournalItem.delete(id: idx) { error in
                    do {
                        try response.redirect(mainPage)
                    } catch let error {
                        response.send(error.localizedDescription)
                    } 
                }
            }
        }
    }
}


     /*
     app.router.get("/journal/all") { _, response, _ in
     let total = journal.total()
     let entries : [Entry] = journal.readAll()
     let count = "\(total)"
     let context  = JournalContext(title: title, author: author, count: count, entries: entries)
     do {
     try response.render("main", with: context)
     } catch let error {
     response.send(error.localizedDescription)
     }
     next()
     }
     
    app.router.get("/journal/create") { request, response, next in
        response.headers["Content-Type"] = "text/html; charset=utf-8"
        try response.render("new", context: ["title": title, "author": author])
    }
    
    app.router.post("/journal/new") { request, response, next in
        guard let entry = try? request.read(as: Entry.self)
            else {
                return try response.status(.unprocessableEntity).end()
        }

        let newID = UUID().uuidString
        if let result = journal.create(Entry(id: newID,
                                             title: entry.title,
                                             content: entry.content)) {
            print("Created: \(result)")
            try response.redirect(mainPage)
        }
    }
    
    app.router.get("/journal/get/:index?") { request, response, next in
        if let index = request.parameters["index"] {
            if let idx = Int(index) {
                if let entry = journal.read(index: idx) {
                    try response.render("entry", context: ["title": title, "author": author, "index": idx, "entry": entry])
                }
            }
        }
    }
    
    app.router.post("/journal/edit/:index?") { request, response, next in
        if let index = request.parameters["index"] {
            if let idx = Int(index) {
                if let entry = try? request.read(as: Entry.self) {
                    if let result = journal.update(index: idx, entry: entry) {
                        print("Updated: Entry[\(index)]: \(result)")
                        try response.redirect(mainPage)
                    }
                }
                else {
                    return try response.status(.unprocessableEntity).end()
                }
            }
        }
    }
    
    app.router.get("/journal/remove/:index?") { request, response, next in
        if let index = request.parameters["index"] {
            if let idx = Int(index) {
                if let entry = journal.delete(index: idx) {
                    print("Deleted: Entry[\(index)]: \(entry)")
                    try response.redirect(mainPage)
                }
            }
        }
    }
 */
//}
