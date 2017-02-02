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
    
    func test_equality_withMatchingProperties_isEqual() {
        let user = User(id: "User1", githubLogin: "Login", name: "User1", displayName: "User1")
        let user2 = user
        
        XCTAssertEqual(user, user2)
    }
    
    func test_equality_withDifferentID_isNotEqual() {
        let user = User(id: "User1", githubLogin: "Login", name: "User1", displayName: "User1")
        var user2 = user
        user2.id = "User2"
        
        XCTAssertNotEqual(user, user2)
    }
    
    func test_equality_withDifferentLogin_isNotEqual() {
        let user = User(id: "User1", githubLogin: "Login", name: "User1", displayName: "User1")
        var user2 = user
        user2.githubLogin = "Login2"
        
        XCTAssertNotEqual(user, user2)
    }
    
    func test_equality_withDifferentName_isNotEqual() {
        let user = User(id: "User1", githubLogin: "Login", name: "User1", displayName: "User1")
        var user2 = user
        user2.name = "User2"
        
        XCTAssertNotEqual(user, user2)
    }
    
    func test_equality_withDifferentDisplayName_isNotEqual() {
        let user = User(id: "User1", githubLogin: "Login", name: "User1", displayName: "User1")
        var user2 = user
        user2.displayName = "User2"
        
        XCTAssertNotEqual(user, user2)
    }
    
}
