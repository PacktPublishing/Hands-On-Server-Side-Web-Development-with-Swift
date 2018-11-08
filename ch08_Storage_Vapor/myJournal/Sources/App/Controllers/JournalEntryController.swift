

import Vapor

final class JournalEntryController {
    
    func create(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.content.decode(JournalEntry.self).flatMap { entry in
            return entry.save(on: req)
        }.transform(to: .ok)
    }
    
    func readAll(_ req: Request) throws -> Future<[JournalEntry]> {
        return JournalEntry.query(on: req).all()
    }
    
    func read(_ req: Request) throws -> Future<JournalEntry?> {
        let id = try req.parameters.next(Int.self)
        return JournalEntry.find(id, on: req)
        //return try req.parameters.next(JournalEntry.self)
    }
    
    func update(_ req: Request) throws -> Future<HTTPStatus> {
        return try flatMap(to: JournalEntry.self,
                           req.content.decode(JournalEntry.self),
                           req.parameters.next(JournalEntry.self)) {
            updated, entry in
            entry.title = updated.title
            entry.content = updated.content
            return entry.save(on: req)
        }.transform(to: .ok)
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(JournalEntry.self).flatMap { entry in
            return entry.delete(on: req)
            }.transform(to: .ok)
    }
}
