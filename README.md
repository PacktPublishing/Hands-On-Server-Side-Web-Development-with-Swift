## [Get this title for $10 on Packt's Spring Sale](https://www.packt.com/B10893?utm_source=github&utm_medium=packt-github-repo&utm_campaign=spring_10_dollar_2022)
-----
For a limited period, all eBooks and Videos are only $10. All the practical content you need \- by developers, for developers

# Hands-On-Server-Side-Web-Development-with-Swift
Hands-On Server-Side Web Development with Swift, published by Packt

<a href="https://india.packtpub.com/in//web-development/hands-server-side-web-development-swift?utm_source=github&utm_medium=repository&utm_campaign=9781789341171"><img src="https://www.packtpub.com/sites/default/files/B10893.png" alt="Hands-On Server-Side Web Development with Swift" height="256px" align="right"></a>

This is the code repository for [Hands-On Server-Side Web Development with Swift](https://www.packtpub.com/web-development/hands-server-side-web-development-swift?utm_source=github&utm_medium=repository&utm_campaign=9781789341171), published by Packt.

**Build dynamic web apps by leveraging two popular Swift web frameworks**

## What is this book about?
This book is about building professional web applications and web services using Swift 4.0 and leveraging two popular Swift web frameworks: Vapor 3.0 and Kitura 2.5. In the first part of this book, we’ll focus on the creation of basic web applications from Vapor and Kitura boilerplate projects. As the web apps start out simple, more useful techniques, such as unit test development, debugging, logging, and the build and release process, will be introduced to readers.

This book covers the following exciting features:
* Build simple web apps using Vapor 3.0 and Kitura 2.5
* Test, debug, build, and release server-side Swift applications
* Design routes and controllers for custom client requests
* Work with server-side template engines
* Deploy web apps to a host in the cloud

If you feel this book is for you, get your [copy](https://www.amazon.com/dp/1789341175) today!

<a href="https://www.packtpub.com/?utm_source=github&utm_medium=banner&utm_campaign=GitHubBanner"><img src="https://raw.githubusercontent.com/PacktPublishing/GitHub/master/GitHub.png" 
alt="https://www.packtpub.com/" border="5" /></a>


## Instructions and Navigations
All of the code is organized into folders. For example, Chapter02.

The code will look like the following:
```
router.post("new") { req -> Future<HTTPStatus> in
    return req.content.decode(Entry.self).map { entry in
        print("Appended a new entry: \(entry)")
        return HTTPStatus.ok
    }
}
```

**Following is what you need for this book:**
Copy and paste the Audience section from the EPIC.

With the following software and hardware list you can run all code files present in the book (Chapter 1-16).

### Software and Hardware List

| Chapter  | Software required                   | OS required                        |
| -------- | ------------------------------------| -----------------------------------|
| 2-9,11-13| Swift 4.2.1 Vapor 3.0 Kitura 2.5    | Mac OS                             |
| 2-9,11,12| Xcode 10.1 (Optional)               | Mac OS                             |
| 13       | Xcode 10.1 (Optional)               | Mac OS                             |


### Related products <Other books you may enjoy>
* Hands-On Full-Stack Development with Swift [[Packt]](https://www.packtpub.com/web-development/hands-full-stack-development-swift?utm_source=github&utm_medium=repository&utm_campaign=9781788625241) [[Amazon]](https://www.amazon.com/dp/1788625242)

* Learn Swift by Building Applications [[Packt]](https://www.packtpub.com/application-development/learn-swift-building-applications?utm_source=github&utm_medium=repository&utm_campaign=9781786463920) [[Amazon]](https://www.amazon.com/dp/178646392X)

## Get to Know the Author
**Angus Yeung**
works for Intel Corp., responsible for the architectural design of back-end cloud services for virtual reality sports broadcasting. He is also a computer science lecturer at San Jose State University. Prior to Intel, he held CTO and engineering director positions in several companies including a start-up he founded in 2002.
Angus' technical interests include mobile computing, distributed computing, computer vision and artificial intelligence. He holds BS, MS and PHD in Electrical Engineering from Univ. of Rochester, and MBA from UC Berkeley. Angus owns 18 pending and granted patents. Angus lives with his lovely wife and three handsome boys in Palo Alto, California.


### Suggestions and Feedback
[Click here](https://docs.google.com/forms/d/e/1FAIpQLSdy7dATC6QmEL81FIUuymZ0Wy9vH1jHkvpY57OiMeKGqib_Ow/viewform) if you have any feedback or suggestions.
