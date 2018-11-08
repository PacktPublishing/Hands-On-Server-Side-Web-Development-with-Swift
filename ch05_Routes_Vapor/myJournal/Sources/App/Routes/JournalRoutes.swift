import Vapor

struct JournalRoutes : RouteCollection {
    
    let journal = JournalController()
    
    func boot(router: Router) throws {
        
        let topRouter = router.grouped("journal")
        topRouter.get("total", use: getTotal)
        topRouter.post("new", use: newEntry)
        
        let entryRouter = router.grouped("journal", Int.parameter)
        entryRouter.get("get", use: getEntry)
        entryRouter.post("edit", use: editEntry)
        entryRouter.get("remove", use: removeEntry)
    }
    
    func getTotal(_ req: Request) -> String {
        let total = journal.total()
        return "\(total)"
    }
    
    func newEntry(_ req: Request) throws -> Future<HTTPStatus> {
        let newID = UUID().uuidString
        return try req.content.decode(Entry.self).map(to: HTTPStatus.self) { entry in
            if let result = self.journal.create(Entry(id: newID,
                                                      title: entry.title,
                                                      content: entry.content)) {
                print("Created: \(result)")
            }
            return .ok
        }
    }
    
    func getEntry(_ req: Request) throws -> Entry {
        let index = try req.parameters.next(Int.self)
        print("Index = \(index)")
        let res = req.makeResponse()
        if let entry = journal.read(index: index) {
            try res.content.encode(entry, as: .formData)
            print("Read: \(entry)")
            return entry
        }
        return Entry(id: "-1")
    }
    
    func editEntry(_ req: Request) throws -> Future<HTTPStatus> {
        let index = try req.parameters.next(Int.self)
        let newID = UUID().uuidString
        return try req.content.decode(Entry.self).map(to: HTTPStatus.self) { entry in
            if let result = self.journal.update(index: index,
                                          entry: Entry(id: newID,
                                                       title: entry.title,
                                                       content: entry.content)) {
                print("Updated: \(result)")
            }
            return .ok
        }
    }

    func removeEntry(_ req: Request) throws -> HTTPStatus {
        let index = try req.parameters.next(Int.self)
        if let result = self.journal.delete(index: index) {
            print("Deleted: \(result)")
        }
        return HTTPStatus.ok
    }
}
