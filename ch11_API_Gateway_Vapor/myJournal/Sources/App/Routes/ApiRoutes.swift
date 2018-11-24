import Vapor
import Leaf
import Authentication
import Crypto

struct ApiRoutes : RouteCollection {
    
    func boot(router: Router) throws {

        //let authSession = Admin.basicAuthMiddleware(using: BCryptDigest())
        //let authRouter = router.grouped(authSession)
        //let publicRouter = authRouter.grouped("/journal/api")
        let apiRouter = router.grouped("/api")
        
        let publicRouter = apiRouter.grouped("/journal")
        
        // public routes
        publicRouter.get("", use: getAll)

        // admin routes
        let adminRouter = apiRouter.grouped("/admin")
        adminRouter.post(use: newEntry)
        adminRouter.get(Int.parameter, use: getEntry)
        adminRouter.put(Int.parameter, use: editEntry)
        adminRouter.delete(Int.parameter, use: removeEntry)
    }

    // public routes
     func getAll(_ req: Request) throws -> Future<[JournalEntry]> {
        return JournalEntry.query(on: req).all()
    }
   
    // admin routes
    func newEntry(_ req: Request) throws -> Future<JournalEntry> {
        return try req.content.decode(JournalEntry.self)
            .flatMap(to: JournalEntry.self) { entry in
                return entry.save(on: req)
            }
    }

    func getEntry(_ req: Request) throws -> Future<JournalEntry> {
        let id = try req.parameters.next(Int.self)
        return JournalEntry.find(id, on: req).unwrap(or: Abort(.notFound))
    }

    func editEntry(_ req: Request) throws -> Future<JournalEntry> {
        let id = try req.parameters.next(Int.self)
        return try req.content.decode(JournalEntry.self).flatMap { updated in
            return JournalEntry.find(id, on: req)
                .flatMap(to: JournalEntry.self) { original in
                    guard let original = original else { throw Abort(.notFound) }
                    original.title = updated.title
                    original.content = updated.content
                    return original.save(on: req)
            }
            }
    }

    func removeEntry(_ req: Request) throws -> Future<HTTPStatus> {
        let id = try req.parameters.next(Int.self)
        return JournalEntry.find(id, on: req).flatMap { entry in
            guard let entry = entry else { throw Abort(.notFound) }
            return entry.delete(on: req).transform(to: HTTPStatus.noContent)
        }
    }
}
