import Vapor
import Leaf
import Authentication

struct JournalRoutes : RouteCollection {
    
    let mainPage = "/journal/all"
    let accountsPage = "/journal/account/all"
    let loginPage = "/journal/login"
    let loginPageWithError = "/journal/login?error"
    let loginPageNeedLogin = "/journal/login?login"

    let title = "My Journal"
    let author = "Angus"
    
    struct AccountsContext : Encodable {
        let isAdmin: Bool
        let title: String
        let author: String
        let count: String
        let admins: [Admin]
    }
    
    struct JournalContext : Encodable {
        let isAdmin: Bool
        let title: String
        let author: String
        let count: String
        let entries: [JournalEntry]
    }
    
    struct LoginContext : Encodable {
        let login: Bool
        let error: Bool
        let title: String
        let author: String
    }
    
    struct CreateContext : Encodable {
        let isAdmin: Bool
        let title: String
        let author: String
    }
    
    struct EntryContext : Encodable {
        let isAdmin: Bool
        let title: String
        let author: String
        let entry: JournalEntry
    }
    
    func boot(router: Router) throws {
        
        let authSession = Admin.authSessionsMiddleware()
        let authRouter = router.grouped(authSession)
        let publicRouter = authRouter.grouped("journal")
        
        // public routes
        publicRouter.get("", use: getAll)
        publicRouter.get("all", use: getAll)
        publicRouter.get("login", use: showLogin)
        publicRouter.post("auth", use: checkLogin)
        publicRouter.get("logout", use: logout)
        
        let securedRouter = authRouter.grouped(RedirectMiddleware<Admin>(path: "/journal/login"))
        
        // protected routes: entries
        let adminRouter = securedRouter.grouped("journal/admin")
        adminRouter.get("create", use: createEntry)
        adminRouter.post("new", use: newEntry)
        adminRouter.get(Int.parameter, "get", use: getEntry)
        adminRouter.post(Int.parameter, "edit", use: editEntry)
        adminRouter.get(Int.parameter, "remove", use: removeEntry)
        
        // protected routes: accounts
        let accountRouter = securedRouter.grouped("journal/account")
        accountRouter.get("all", use: getAccounts)
        accountRouter.get("add", use: addAccount)
        accountRouter.post("new", use: newAccount)
        accountRouter.get(Int.parameter, "remove", use: removeAccount)
    }
    
    func getAccounts(_ req: Request) throws -> Future<View> {
        return Admin.query(on: req).all().flatMap(to: View.self) { admins in
            let isAdmin = try req.isAuthenticated(Admin.self)
            let context = AccountsContext(isAdmin: isAdmin,
                                         title: self.title,
                                         author: self.author,
                                         count: String(admins.count),
                                         admins: admins)
            let leaf = try req.make(LeafRenderer.self)
            return leaf.render("accounts", context)
        }
    }
    
    func addAccount(_ req: Request) throws ->  Future<View> {
        let leaf = try req.make(LeafRenderer.self)
        let isAdmin = try req.isAuthenticated(Admin.self)
        let context = CreateContext(isAdmin: isAdmin,
                                    title: self.title,
                                    author: self.author)
        return leaf.render("add_account", context)
    }
    
    func newAccount(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(Admin.self).flatMap(to: Admin.self) { admin in
            admin.password = try BCrypt.hash(admin.password)
            return admin.save(on: req)
        }.transform(to: req.redirect(to: self.accountsPage))
    }
   
    func removeAccount(_ req: Request) throws -> Future<Response> {
        let id = try req.parameters.next(Int.self)
        return Admin.find(id, on: req).flatMap { admin in
            guard let admin = admin else { throw Abort(.notFound) }
            return admin.delete(on: req).transform(to: req.redirect(to: self.accountsPage))
        }
    }

    func getAll(_ req: Request) throws -> Future<View> {
        return JournalEntry.query(on: req).all().flatMap(to: View.self) { entries in
            let isAdmin = try req.isAuthenticated(Admin.self)
            let context = JournalContext(isAdmin: isAdmin,
                                         title: self.title,
                                         author: self.author,
                                         count: String(entries.count),
                                         entries: entries)
            let leaf = try req.make(LeafRenderer.self)
            return leaf.render("main", context)
        }
    }

    func createEntry(_ req: Request) throws -> Future<View> {
        let leaf = try req.make(LeafRenderer.self)
        let isAdmin = try req.isAuthenticated(Admin.self)
        let context = CreateContext(isAdmin: isAdmin,
                                    title: self.title,
                                    author: self.author)
        return leaf.render("new", context)
    }
    
    func newEntry(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(JournalEntry.self).flatMap { entry in
            return entry.save(on: req)
        }.transform(to: req.redirect(to: self.mainPage))
    }
    
    func showLogin(_ req: Request) throws -> Future<View> {
        let leaf = try req.make(LeafRenderer.self)
        var loginError : Bool = false
        var loginRequired : Bool = false
        if req.query[Bool.self, at: "error"] != nil { loginError = true } 
        if req.query[Bool.self, at: "login"] != nil { loginRequired = true } 

        let context = LoginContext(login: loginRequired,
                                   error: loginError,
                                   title: self.title,
                                   author: self.author)
        return leaf.render("login", context)
    }
    
    func checkLogin(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(Admin.self).flatMap { candidate in
            return Admin.authenticate(username: candidate.login,
                                      password: candidate.password,
                                      using: BCryptDigest(),
                                      on: req).map { admin in
                                        guard let admin = admin else {
                                            return req.redirect(to: self.loginPageWithError)
                                        }
                                        try req.authenticateSession(admin)
                                        return req.redirect(to: self.mainPage)
            }
        }
    }
    
    func logout(_ req: Request) throws -> Response {  // no async call
        try req.unauthenticateSession(Admin.self)
        return req.redirect(to: self.mainPage)
    }

    func getEntry(_ req: Request) throws -> Future<View> {
        let id = try req.parameters.next(Int.self)
        return JournalEntry.find(id, on: req).flatMap(to: View.self) { entry in
            guard let entry = entry else { throw Abort(.notFound) }
            let leaf = try req.make(LeafRenderer.self)
            let isAdmin = try req.isAuthenticated(Admin.self)
            let context = EntryContext(isAdmin: isAdmin,
                                       title: self.title,
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
