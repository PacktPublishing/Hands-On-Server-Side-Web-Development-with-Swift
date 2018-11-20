import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health
import Dispatch

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
        
        let journalRoutes = JournalRoutes()
        
        // Endpoints
        initializeHealthRoutes(app: self)
        
        router.get("/journal") { _, response, _ in
            let total = journalRoutes.getTotal()
            response.send("\(total)")
        }
        
        router.post("/journal", handler: journalRoutes.newEntry)
        router.get("/journal", handler: journalRoutes.getEntry)
        router.put("/journal", handler: journalRoutes.editEntry)
        router.delete("/journal", handler: journalRoutes.removeEntry)
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
}
