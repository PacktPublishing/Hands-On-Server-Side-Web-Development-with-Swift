@testable import App
import XCTest
import Vapor

final class AppTests: XCTestCase {
 
    func testNothing() throws {
        // add your tests here
        XCTAssert(true)
    }
    func testStudent() throws {

        let myApp = try app(Environment.testing)
        
        let studentRecords = [
            "Peter" : 3.42,
            "Thomas" : 2.98,
            "Jane" : 3.91,
            "Ryan" : 4.00,
            "Kyle" : 4.00
        ]
        
        for (studentName, gpa) in studentRecords {
            
            let query = "/student/" + studentName;
            let request = Request(http: HTTPRequest(method: .GET,
                                                    url: URL(string: query)!),
                                  using: myApp)
            
            let response = try myApp.make(Responder.self).respond(to: request).wait()
            
            guard let data = response.http.body.data else {
                XCTFail("No data in response")
                return
            }
            
            let expectedResponse = "The student \(studentName)'s GPA is \(gpa)"
            
            if let responseString = String(data: data, encoding: .utf8) {
                XCTAssertEqual(responseString, expectedResponse)
            }
        }
    }

    static let allTests = [
        ("testNothing", testNothing),
        ("testStudent", testStudent)
    ]
}
