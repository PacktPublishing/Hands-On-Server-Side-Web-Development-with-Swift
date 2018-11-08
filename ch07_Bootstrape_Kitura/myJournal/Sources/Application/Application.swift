import Foundation
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
        
        let journal = JournalController()
        let journalHandlers = JournalHandlers(journal: journal)
        
        router.setDefault(templateEngine: StencilTemplateEngine())
        router.get("/", middleware: StaticFileServer())

        // Endpoints
        initializeHealthRoutes(app: self)
        initializeJournalRoutes(app: self, journal: journal)

        router.post("/journal/api/new", handler: journalHandlers.newEntry)
        router.get("/journal/api/get", handler: journalHandlers.getEntry)
        router.put("/journal/api/edit", handler: journalHandlers.editEntry)
        router.delete("/journal/api/remove", handler: journalHandlers.removeEntry)
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
}

struct User: Codable, QueryParams {
    let name: String
    let age: Int
}
