import Vapor
import Leaf
import Authentication

struct ApiRoutes : RouteCollection {
    
    func boot(router: Router) throws {
        
//        let authSession = Admin.basicAuthMiddleware(using: BCryptDigest())
//        let authRouter = router.grouped(authSession)
//        let publicRouter = authRouter.grouped("/journal/api")
        
        let publicRouter = router.grouped("/journal/api")
        
        // public routes
        publicRouter.get("", use: getAll)
        publicRouter.get("all", use: getAll)
//        publicRouter.post("auth", use: checkLogin)
//        publicRouter.get("unauth", use: handleUnauth)
 //       publicRouter.get("logout", use: logout)
        
//        let securedRouter = authRouter.grouped(RedirectMiddleware<Admin>(path: "/api/unauth"))
        
        // protected routes: entries
//        let adminRouter = securedRouter.grouped("/admin")
        let adminRouter = publicRouter.grouped("/admin")
        adminRouter.post(use: newEntry)
        adminRouter.get(Int.parameter, use: getEntry)
        adminRouter.put(Int.parameter, use: editEntry)
        adminRouter.delete(Int.parameter, use: removeEntry)
        
        // protected routes: accounts
//        let accountRouter = securedRouter.grouped("/account")
        let accountRouter = publicRouter.grouped("/account")
        accountRouter.get(use: getAccounts)
        accountRouter.post(use: newAccount)
        accountRouter.delete(Int.parameter, use: removeAccount)
    }

    func getAccounts(_ req: Request) throws -> Future<[Admin]> {
        return Admin.query(on: req).all()
    }

    func newAccount(_ req: Request) throws -> Future<Admin> {
        return try req.content.decode(Admin.self).flatMap(to: Admin.self) { admin in
            admin.password = try BCrypt.hash(admin.password)
            return admin.save(on: req)
        }
    }
    
    func handleUnauth(_ req: Request) throws -> HTTPStatus {
       return HTTPStatus.unauthorized
    }

    func removeAccount(_ req: Request) throws -> Future<HTTPStatus> {
        let id = try req.parameters.next(Int.self)
        return Admin.find(id, on: req).flatMap { admin in
            guard let admin = admin else { throw Abort(.notFound) }
            return admin.delete(on: req).transform(to: HTTPStatus.noContent)
        }
    }

    func getAll(_ req: Request) throws -> Future<[JournalEntry]> {
        return JournalEntry.query(on: req).all()
    }
    
    func checkLogin(_ req: Request) throws -> Future<AdminToken> {
        let admin = try req.requireAuthenticated(Admin.self)
        let token = try AdminToken.generateToken(for: admin)
        return token.save(on: req)
    }

    func newEntry(_ req: Request) throws -> Future<JournalEntry> {
        return try req.content.decode(JournalEntry.self)
            .flatMap(to: JournalEntry.self) { entry in
                return entry.save(on: req)
            }
    }

    func getEntry(_ req: Request) throws -> Future<JournalEntry> {
        return try req.parameters.next(JournalEntry.self)
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
