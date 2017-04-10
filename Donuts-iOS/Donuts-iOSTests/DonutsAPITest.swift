//
//  DonutsAPITest.swift
//  Donuts-iOS
//
//  Created by Chris Rittersdorf on 4/10/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//
@testable import Donuts_iOS
import XCTest

class DonutsAPI {
    func getTodayClaims(completion: ([User])->()) {
        let users = [User]()
        completion(users)
    }
}

class DonutsAPITest: XCTestCase {
    let donutsAPI = DonutsAPI()
    
    func test_getTodayClaims_whenNoClaimsOnServer_returnsEmptyUserList() {
        
        expectWithCallbacks(description: "emptyClaims") { (expectation) in
            donutsAPI.getTodayClaims { users in
                XCTAssertTrue(users.isEmpty)
                expectation.fulfill()
            }
        }
    }
}
