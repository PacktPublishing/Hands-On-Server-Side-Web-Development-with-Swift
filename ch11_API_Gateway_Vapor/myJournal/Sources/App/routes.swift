import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let apiRoutes = ApiRoutes()
    try router.register(collection: apiRoutes)
}
