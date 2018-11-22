//
//  JournalRoutes.swift
//  Application
//
//  Created by Angus yeung on 7/16/18.
//

import Foundation
import KituraStencil
import Kitura

func initializeJournalRoutes(app: App, journal: JournalController) {
    
    let mainPage = "/journal/all"
    
    let title = "My Journal"
    let author = "Angus"
    
    struct JournalContext : Encodable {
        let title: String
        let author: String
        let count: String
        let entries: [Entry]
    }

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
        guard let index = request.parameters["index"]  else {
            return try response.status(.badRequest).send("Missing entry index").end()
        }
        guard let idx = Int(index) else {
            return try response.status(.badRequest).send("Invalid entry index").end()
        }
        guard let entry = journal.read(index: idx) else {
            return try response.status(.unprocessableEntity).end()
        }
        try response.render("entry", context: ["title": title, "author": author, "index": idx, "entry": entry])
    }
    
    app.router.post("/journal/edit/:index?") { request, response, next in
        guard let index = request.parameters["index"]  else {
            return try response.status(.badRequest).send("Missing entry index").end()
        }
        guard let idx = Int(index) else {
            return try response.status(.badRequest).send("Invalid entry index").end()
        }
        if let entry = try? request.read(as: Entry.self) {
            if let result = journal.update(index: idx, entry: entry) {
                print("Updated: Entry[\(index)]: \(result)")
                try response.redirect(mainPage)
            }
        }
        try response.status(.unprocessableEntity).end()
    }
    
    app.router.get("/journal/remove/:index?") { request, response, next in
        guard let index = request.parameters["index"]  else {
            return try response.status(.badRequest).send("Missing entry index").end()
        }
        guard let idx = Int(index) else {
            return try response.status(.badRequest).send("Invalid entry index").end()
        }
        if let entry = journal.delete(index: idx) {
            print("Deleted: Entry[\(index)]: \(entry)")
            try response.redirect(mainPage)
        }
        try response.status(.unprocessableEntity).end()
    }
}
