//
//  APITest.swift
//  Donuts-iOS
//
//  Created by Ben Lambert on 1/25/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import XCTest

class APITest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_getTodayClaims_whenNoClaimsOnServer_returnsEmptyUserList() {
        let donutsApi = DonutsAPI()
        let asyncExpectation = expectation(description: "getTodayClaims()")
        
        donutsApi.getTodayClaims() { users in
            XCTAssertTrue(users.isEmpty)
            asyncExpectation.fulfill()
            
        }
        waitForExpectations(timeout: 1) { (error) in
            if let error = error {
                XCTFail("getTodayClaims Timeout errored: \(error)")
            }
        }
    }
}

class DonutsAPI {
    func getTodayClaims(completion: ([User]) -> ()) {
        completion([User]())
    }
}

/*
struct DonutsAPI {
    static let url = "/api/v1/claims/today"
}

struct DonutService {
    
    func getTodaysClaims() {
        
    }
    
}
 */
