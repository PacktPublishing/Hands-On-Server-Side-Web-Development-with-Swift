// import FluentSQLite
import FluentPostgreSQL
import Leaf
import Vapor


/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    // try services.register(FluentSQLiteProvider())
    try services.register(FluentPostgreSQLProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    /// Register Leaf templating engine
    try services.register(LeafProvider())

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    let postgresql = PostgreSQLDatabase(config: PostgreSQLDatabaseConfig(hostname: "localhost",
                                                                         username: "fyeung1",
                                                                         database: "myjournal"))
//    let sqlite = try SQLiteDatabase(storage: .memory)
    //let sqlite = try SQLiteDatabase(storage: .file(path: "db.sqlite"))
    
    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    // databases.add(database: sqlite, as: .sqlite)
    databases.add(database: postgresql, as: .psql)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: JournalEntry.self, database: .psql)
    //migrations.add(model: JournalEntry.self, database: .sqlite)
    services.register(migrations)

    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
}
