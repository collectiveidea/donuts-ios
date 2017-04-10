//
//  UserTest.swift
//  Donuts-iOS
//
//  Created by Chris Rittersdorf on 4/10/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

@testable import Donuts_iOS
import XCTest


class UserTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testJsonMapping_returnsValidUser() {
        let json = fixtureJson(name: "user")!
        let user = User(fromJSON: json)
        
        XCTAssert("63db9251-9c45-41ca-92d6-15e84ebea5b3" == user.id)
        XCTAssert("be-bert" == user.githubLogin)
        XCTAssert("Be-Bert" == user.name)
        XCTAssert("Be-Bert" == user.displayName)
    }
}
