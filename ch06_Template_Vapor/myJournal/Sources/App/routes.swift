import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    let journalRoutes = JournalRoutes()
    try router.register(collection: journalRoutes)
}
