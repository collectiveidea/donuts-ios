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
    
    func test_urlFor_getTodayClaims_usesBaseUrl() {
        let donutsApi = DonutsAPI(baseUrl: "https://donuts.test")
        XCTAssertEqual("https://donuts.test/api/v1/claims/today", donutsApi.urlFor(path: "claims/today"))
    }
    
    func test_getTodayClaims_callsNetworkApi() {
        let donutHost = "donuts.test"
        let donutsApi = DonutsAPI(baseUrl: "https://\(donutHost)")
        
        let asyncExpectation = expectation(description: "getTodayClaims()")
        var todayClaimsCallCount = 0
        
        stub(condition: isScheme("https") && isHost(donutHost) && isMethodGET() && isPath("/api/v1/claims/today")) { _ in
            // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
            return OHHTTPStubsResponse()
            }.name = "todaysClaimsNetwork"
        
        OHHTTPStubs.onStubActivation { (request, stub, response) in
            if stub.name == "todaysClaimsNetwork" {
                todayClaimsCallCount += 1
            }
        }
        
        donutsApi.getTodayClaims() { users in
            XCTAssertEqual(1, todayClaimsCallCount)
            asyncExpectation.fulfill()
            
        }
        waitForExpectations(timeout: 1) { (error) in
            if let error = error {
                XCTFail("getTodayClaims Timeout errored: \(error)")
            }
        }
    }
    
    func test_getTodayClaims_whenNoClaimsOnServer_returnsEmptyUserList() {
        let donutsApi = DonutsAPI(baseUrl: "https://donuts.test)")
        
        let asyncExpectation = expectation(description: "getTodayClaims()")
        
        stub(condition: isMethodGET() && isPath("/api/v1/claims/today")) { _ in
            // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
            return OHHTTPStubsResponse(
                data: "[]".data(using: String.Encoding.utf8)!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }.name = "todaysClaimsEmpty"
        
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
    
    func test_getTodayClaims_withClaimsOnServer_returnsListOfThoseUsers() {
        let donutsApi = DonutsAPI(baseUrl: "https://donuts.test")
        
        let asyncExpectation = expectation(description: "getTodayClaims()")
        
        stub(condition: isMethodGET() && isPath("/api/v1/claims/today")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("users.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }.name = "todaysClaimsFull"

        donutsApi.getTodayClaims { users in
            XCTAssertEqual(users, TestUsers.users, "Users do not match Test Data")

            asyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("getTodayClaims Timeout errored: \(error)")
            }
        }
    }
    
    struct TestUsers {
        // these users use the same values that are in the users.json
        
        private static let user1 = User(id: "63db9251-9c45-41ca-92d6-15e84ebea5b3", githubLogin: "vgonda", name: "Victoria Gonda", displayName: "Victoria")
        
        private static let user2 = User(id: "73db9251-9c45-41ca-92d6-15e84ebea5b3", githubLogin: "bebert", name: "Be-Bert", displayName: "Be-Bert")
        
        static let users = [user1, user2]
    }
}

class DonutsAPI {
    let baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func urlFor(path: String) -> String {
        return "\(baseUrl)/api/v1/\(path)"
    }
    
    func getTodayClaims(completion: @escaping ([User]) -> ()) {
        Alamofire.request(urlFor(path: "claims/today")).responseJSON { (response) in
            if let json = response.result.value as? [[String:Any?]] {
                let users = json.flatMap { User(fromJSON: $0) }
                completion(users)
            } else {
                completion([User]())
            }
        }
    }
}
