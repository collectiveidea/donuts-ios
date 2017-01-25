//
//  APITest.swift
//  Donuts-iOS
//
//  Created by Ben Lambert on 1/25/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import XCTest
import OHHTTPStubs
import Alamofire

class APITest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func test_getTodayClaims_whenNoClaimsOnServer_returnsEmptyUserList() {
        let donutHost = "donuts.test"
        let donutsApi = DonutsAPI(baseUrl: "https://\(donutHost)")
        let asyncExpectation = expectation(description: "getTodayClaims()")
        var todayClaimsCallCount = 0
        
        stub(condition: isScheme("https") && isHost(donutHost) && isMethodGET() && isPath("/api/v1/claims/today")) { _ in
            // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
            return OHHTTPStubsResponse(
                data: "[]".data(using: String.Encoding.utf8)!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }.name = "todaysClaimsEmpty"
        
        OHHTTPStubs.onStubActivation { (request, stub, response) in
            if stub.name == "todaysClaimsEmpty" {
                todayClaimsCallCount += 1
            }
        }
        
        donutsApi.getTodayClaims() { users in
            XCTAssertTrue(users.isEmpty)
            XCTAssertEqual(1, todayClaimsCallCount)
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
    let baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func getTodayClaims(completion: @escaping ([User]) -> ()) {
        Alamofire.request("\(baseUrl)/api/v1/claims/today").responseJSON { (response) in
            if let json = response.result.value as? [[String:Any?]] {
                let users = json.map { User(fromJSON: $0) }
                completion(users)
            } else {
                completion([User]())
            }
        }
    }
}
