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

        XCTAssertTrue(donutsApi.getTodayClaims().isEmpty)
    }
}

class DonutsAPI {
    func getTodayClaims() -> [User] {
        return [User]()
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
