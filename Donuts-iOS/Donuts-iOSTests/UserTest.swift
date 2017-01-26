//
//  UserTest.swift
//  Donuts-iOS
//
//  Created by Josh Kovach on 1/23/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import XCTest

class UserTest: XCTestCase {
    
    func testJsonMapping_returnsValidUser() {
        if let json = fixtureJson(name: "user") {
            let user = User(fromJSON: json)
            
            XCTAssert("63db9251-9c45-41ca-92d6-15e84ebea5b3" == user.id)
            XCTAssert("vgonda" == user.githubLogin)
            XCTAssert("Victoria Gonda" == user.name)
            XCTAssert("Victoria" == user.displayName)
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
    
    func test_equality_withAnyPropertyMismatched_isNotEqual() {
        let primary = User(id: "hello", githubLogin: "hello", name: "Hello World", displayName: "Hello")
        let primaryCopy = User(id: "hello", githubLogin: "hello", name: "Hello World", displayName: "Hello")
        let idDiff = User(id: "hell", githubLogin: "hello", name: "Hello World", displayName: "Hello")
        let loginDiff = User(id: "hello", githubLogin: "hellob", name: "Hello World", displayName: "Hello")
        let nameDiff = User(id: "hello", githubLogin: "hello", name: "Hello Worlds", displayName: "Hello")
        let displayNameDiff = User(id: "hello", githubLogin: "hello", name: "Hello World", displayName: "Hellos")
        
        XCTAssertEqual(primary, primaryCopy)
        XCTAssertNotEqual(primary, idDiff)
        XCTAssertNotEqual(primary, loginDiff)
        XCTAssertNotEqual(primary, nameDiff)
        XCTAssertNotEqual(primary, displayNameDiff)
    }
}

struct User: Equatable {
    
    var id: String?
    var githubLogin: String?
    var name: String?
    var displayName: String?
    
    static func ==(lhs: User, rhs: User) -> Bool {
        if (lhs.id == rhs.id &&
            lhs.githubLogin == rhs.githubLogin &&
            lhs.name == rhs.name &&
            lhs.displayName == rhs.displayName) {
            return true
        }
        return false
    }
        
    init(fromJSON json: [String: Any]) {
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
