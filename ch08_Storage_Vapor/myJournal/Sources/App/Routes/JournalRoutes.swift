import Vapor
import Leaf

struct JournalRoutes : RouteCollection {
    
    let mainPage = "/journal/all"
    
    let title = "My Journal"
    let author = "Angus"
    
    struct JournalContext : Encodable {
        let title: String
        let author: String
        let count: String
        let entries: [JournalEntry]
    }
    
    struct EntryContext : Encodable {
        let title: String
        let author: String
        let entry: JournalEntry
    }
    
    func boot(router: Router) throws {
        
        let topRouter = router.grouped("journal")
        topRouter.get("", use: getAll)
        topRouter.get("all", use: getAll)
        topRouter.get("create", use: createEntry)
        topRouter.post("new", use: newEntry)
        
        let entryRouter = router.grouped("journal", Int.parameter)
        entryRouter.get("get", use: getEntry)
        entryRouter.post("edit", use: editEntry)
        entryRouter.get("remove", use: removeEntry)
    }
 
    func getAll(_ req: Request) throws -> Future<View> {
        return JournalEntry.query(on: req).all().flatMap(to: View.self) { entries in
            let context = JournalContext(title: self.title,
                                         author: self.author,
                                         count: String(entries.count),
                                         entries: entries)
            let leaf = try req.make(LeafRenderer.self)
            return leaf.render("main", context)
        }
    }

    func createEntry(_ req: Request) throws -> Future<View> {
        let leaf = try req.make(LeafRenderer.self)
        let context = ["title": title, "author": author]
        return leaf.render("new", context)
    }
 
    func newEntry(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(JournalEntry.self).flatMap { entry in
            return entry.save(on: req)
        }.transform(to: req.redirect(to: self.mainPage))
    }

    func getEntry(_ req: Request) throws -> Future<View> {
        let id = try req.parameters.next(Int.self)
        return JournalEntry.find(id, on: req).flatMap(to: View.self) { entry in
            guard let entry = entry else { throw Abort(.notFound) }
            let leaf = try req.make(LeafRenderer.self)
            let context : EntryContext
            context = EntryContext(title: self.title,
                                   author: self.author,
                                   entry: entry)
            return leaf.render("entry", context)
        }
    }

    func editEntry(_ req: Request) throws -> Future<Response> {
        let id = try req.parameters.next(Int.self)
        return try req.content.decode(JournalEntry.self).flatMap { updated in
            return JournalEntry.find(id, on: req)
                               .flatMap(to: JournalEntry.self) { original in
                                guard let original = original else { throw Abort(.notFound) }
                                original.title = updated.title
                                original.content = updated.content
                                return original.save(on: req)
            }
        }.transform(to: req.redirect(to: self.mainPage))
    }
    func removeEntry(_ req: Request) throws -> Future<Response> {
        let id = try req.parameters.next(Int.self)
        return JournalEntry.find(id, on: req).flatMap { entry in
            guard let entry = entry else { throw Abort(.notFound) }
            return entry.delete(on: req).transform(to: req.redirect(to: self.mainPage))
        }
    }
}
