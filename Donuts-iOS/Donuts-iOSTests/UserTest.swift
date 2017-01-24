//
//  UserTest.swift
//  Donuts-iOS
//
//  Created by Josh Kovach on 1/23/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import XCTest

class UserTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJsonMapping_returnsValidUser() {
        if let json = fixtureJson(name: "user") {
            let user = User(fromJSON: json)
            
            XCTAssert("63db9251-9c45-41ca-92d6-15e84ebea5b3" == user.id)
            XCTAssert("vgonda" == user.githubLogin)
            XCTAssert("Victoria Gonda" == user.name)
            XCTAssert("Victoria" == user.displayName)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func fixtureJson(name: String) -> [String: Any]? {
        if let path = Bundle(for: UserTest.self).path(forResource: name, ofType: "json") {
            
            if let data = try? Data(referencing: NSData(contentsOfFile: path)) {
                
                do {
                    return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                } catch {
                    XCTFail("\(error.localizedDescription)")
                }
            }
        } else {
            XCTFail("Can't find the test JSON file")
        }
        return nil
    }
    
}

class User {
    
    var id: String?
    var githubLogin: String?
    var name: String?
    var displayName: String?
    
    convenience init(fromJSON json: [String: Any]) {
        let id = json["id"] as? String
        let githubLogin = json["github_login"] as? String
        let name = json["name"] as? String
        let displayName = json["display_name"] as? String
        
        self.init(id: id, githubLogin: githubLogin, name: name, displayName: displayName)
    }
    
    init(id: String?, githubLogin: String?, name: String?, displayName: String?) {
        self.id = id
        self.githubLogin = githubLogin
        self.name = name
        self.displayName = displayName
    }
    
}
