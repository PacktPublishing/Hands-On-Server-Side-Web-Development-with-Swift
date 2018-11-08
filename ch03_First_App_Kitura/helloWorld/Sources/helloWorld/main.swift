import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import Application

do {
    
    HeliumLogger.use(LoggerMessageType.verbose)

    Log.debug("Instantiating App()")
    let app = try App()
    Log.debug("Starting to run an instance of App()")
    try app.run()

} catch let error {
    Log.error(error.localizedDescription)
}
