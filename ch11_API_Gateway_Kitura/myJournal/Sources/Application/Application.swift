import Foundation
import CLibpq
import SwiftKueryORM
import SwiftKueryPostgreSQL
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health
import Dispatch
import KituraStencil



public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    let router = Router()
    let cloudEnv = CloudEnv()

    public init() throws {
        // Run the metrics initializer
        initializeMetrics(router: router)
    }

    func postInit() throws {

        router.setDefault(templateEngine: StencilTemplateEngine())
        router.get("/", middleware: StaticFileServer())
        

        // Endpoints
        initializeHealthRoutes(app: self)

        let poolOptions = ConnectionPoolOptions(initialCapacity: 1,
                                                maxCapacity: 5,
                                                timeout: 10000)
        
        // Set up database connection
        let psqlPool = PostgreSQLConnection.createPool(host: "localhost",
                                                   port: 5432,
                                                   options: [.databaseName("journalbook")],
                                                   poolOptions: poolOptions)
        Database.default = Database(psqlPool)

        do {
            try JournalItem.createTableSync()
        } catch let error {
            Log.error("Failed to create table in database: \(error)")
        }

        router.get("/journal/api/all", handler: getAllHandler)
        router.get("/journal/api/admin", handler: getItemHandler)
        router.post("/journal/api/admin", handler: createItemHandler)
        router.put("/journal/api/admin", handler: updateItemHandler)
        router.delete("/journal/api/admin", handler: deleteItemHandler)
        router.delete("/journal/api/admin", handler: deleteItemHandler)
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
}
