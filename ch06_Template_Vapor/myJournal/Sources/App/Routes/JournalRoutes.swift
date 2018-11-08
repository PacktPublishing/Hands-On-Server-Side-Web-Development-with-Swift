import Vapor
import Leaf

struct JournalRoutes : RouteCollection {
    
    let journal = JournalController()
    let mainPage = "/journal/all"
    
    let title = "My Journal"
    let author = "Angus"
    
    struct JournalContext : Encodable {
        let title: String
        let author: String
        let count: String
        let entries: [Entry]
    }
    
    struct EntryContext : Encodable {
        let title: String
        let author: String
        let index: Int
        let entry: Entry
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
        let total = journal.total()
        let entries : [Entry] = journal.readAll()
        let count = "\(total)"
        let leaf = try req.make(LeafRenderer.self)
        let context = JournalContext(title: title, author: author, count: count, entries: entries)
        return leaf.render("main", context)
    }
    
    func createEntry(_ req: Request) throws -> Future<View> {
        let leaf = try req.make(LeafRenderer.self)
        let context = ["title": title, "author": author]
        return leaf.render("new", context)
    }
    
    func newEntry(_ req: Request) throws -> Future<Response> {
        let newID = UUID().uuidString
        return try req.content.decode(Entry.self).map(to: Response.self) { entry in
            if let result = self.journal.create(Entry(id: newID,
                                                      title: entry.title,
                                                      content: entry.content)) {
                print("Created: \(result)")
            }
            return req.redirect(to: self.mainPage)
        }
    }
    
    func getEntry(_ req: Request) throws -> Future<View> {
        let index = try req.parameters.next(Int.self)
        let leaf = try req.make(LeafRenderer.self)
        var entry = Entry(id: "-1")
        if let result = journal.read(index: index) {
            entry = result
        }
        let context = EntryContext(title: title, author: author, index: index, entry: entry)
        return leaf.render("entry", context)
    }
    
    func editEntry(_ req: Request) throws -> Future<Response> {
        let index = try req.parameters.next(Int.self)
        return try req.content.decode(Entry.self).map(to: Response.self) { entry in
            if let result = self.journal.update(index: index,
                                                entry: Entry(id: entry.id,
                                                             title: entry.title,
                                                             content: entry.content)) {
                print("Updated: \(result)")
            }
            return req.redirect(to: self.mainPage)
        }
    }

    func removeEntry(_ req: Request) throws -> Response {
        let index = try req.parameters.next(Int.self)
        if let result = self.journal.delete(index: index) {
            print("Deleted: \(result)")
        }
        return req.redirect(to: mainPage)
    }
}
