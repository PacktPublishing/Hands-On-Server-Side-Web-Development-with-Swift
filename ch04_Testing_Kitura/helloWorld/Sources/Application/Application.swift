import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    let router = Router()
    let cloudEnv = CloudEnv()

    public init() throws {
        // Run the metrics initializer
        Log.debug("Executing App's initializer")
        initializeMetrics(router: router)
    }

    func postInit() throws {
        Log.debug("Executing post-initialization")
        
        // Endpoints
        initializeHealthRoutes(app: self)
        
        router.get("/greet") { request, response, next in
            if let guest = request.queryParameters["guest"] {
                response.send("Hi \(guest), greetings!  Thanks for visiting us.")
            } else {
                response.send("Hi stranger, It's nice meeting with you.")
            }
             next()
        }
        
        router.get("/greet") { request, response, next in
            response.send("  Unfortunately, there is nothing too much to see here.")
        }
        
        router.get("/student/:name") { request, response, next in
            let studentName =  request.parameters["name"]!
            
            let studentRecords = [
                "Peter" : 3.42,
                "Thomas" : 2.98,
                "Jane" : 3.91,
                "Ryan" : 4.00,
                "Kyle" : 4.00
                ]
            
            var queryResponse : String
            
            if let gpa = studentRecords[studentName] {
                queryResponse = "The student \(studentName)'s GPA is \(gpa)"
            } else {
                queryResponse = "The student's record can't be found!"
            }
            response.send(queryResponse)
        }
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
}
