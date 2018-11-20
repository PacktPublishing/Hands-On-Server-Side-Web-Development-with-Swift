import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
    
    router.get("greet", String.parameter) { req -> String in
        let guest = try req.parameters.next(String.self)
        return "Hi \(guest), greetings!  Thanks for visiting us."
    }
    
    router.get("student", String.parameter) { req -> String in
        let studentName = try req.parameters.next(String.self)
        
        let studentRecords = [
            "Peter" : 3.42,
            "Thomas" : 2.98,
            "Jane" : 3.91,
            "Ryan" : 4.00,
            "Kyle" : 4.00
        ]
        
        if let gpa = studentRecords[studentName] {
            return "The student \(studentName)'s GPA is \(gpa)"
        } 
        return "The student's record can't be found!"
    }
}
