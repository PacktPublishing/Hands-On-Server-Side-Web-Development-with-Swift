import Vapor

struct JournalRoutes : RouteCollection {
    
    let journal = JournalController()               // [1]
    
    func boot(router: Router) throws {
        
        let topRouter = router.grouped("journal")   // [2]
        topRouter.get(use: getTotal)
        topRouter.post(use: newEntry)
        
        let entryRouter = router.grouped("journal", Int.parameter) // [3]
        entryRouter.get(use: getEntry)
        entryRouter.put(use: editEntry)
        entryRouter.delete(use: removeEntry)
    }
    
    func getTotal(_ req: Request) -> String {   // [4]
        let total = journal.total()
        print("Total Records: \(total)")
        return "\(total)"
    }
    
    func newEntry(_ req: Request) throws -> Future<HTTPStatus> {    // [5]
        let newID = UUID().uuidString
        return try req.content.decode(Entry.self).map(to: HTTPStatus.self) { entry in
            let newEntry = Entry(id: newID,
                                 title: entry.title,
                                 content: entry.content)
            if let result = self.journal.create(newEntry) {
                print("Created: \(result)")
            }
            return .ok
        }
    }
    
    func getEntry(_ req: Request) throws -> Entry {     // [6]
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
    
    func editEntry(_ req: Request) throws -> Future<HTTPStatus> {      // [7]
        let index = try req.parameters.next(Int.self)
        let newID = UUID().uuidString
        return try req.content.decode(Entry.self).map(to: HTTPStatus.self) { entry in
            let newEntry = Entry(id: newID,
                                 title: entry.title,
                                 content: entry.content)
            if let result = self.journal.update(index: index, entry: newEntry) {
                print("Updated: \(result)")
            }
            return .ok
        }
    }

    func removeEntry(_ req: Request) throws -> HTTPStatus {     // [8]
        let index = try req.parameters.next(Int.self)
        if let result = self.journal.delete(index: index) {
            print("Deleted: \(result)")
        }
        return HTTPStatus.ok
    }
}
