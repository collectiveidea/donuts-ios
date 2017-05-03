//
//  DonutsAPITest.swift
//  Donuts-iOS
//
//  Created by Chris Rittersdorf on 4/10/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//
@testable import Donuts_iOS
import XCTest
import OHHTTPStubs

extension OHHTTPStubs {
    static func anyRequest() -> OHHTTPStubsTestBlock {
        return { _ in return true }
    }
}


struct TestUsers {
    private static let user1 = User(
        id: "63db9251-9c45-41ca-92d6-15e84ebea5b3",
        githubLogin: "shekibobo",
        name: "Josh Kovach",
        displayName: "Josh"
    )

    private static let user2 = User(
        id: "73db9251-9c45-41ca-92d6-15e84ebea5b3",
        githubLogin: "bebert",
        name: "Be-Bert",
        displayName: "Be-Bert"
    )
    
    static let users: [User] = [user1, user2]
}


class DonutsAPITest: XCTestCase {
    let donutsAPI = DonutsAPI(baseURL: "https://donuts.example.com")
    
    let todayClaimsEmptyResponse: OHHTTPStubsResponseBlock = { _ in
        return OHHTTPStubsResponse(
            data: "[]".data(using: String.Encoding.utf8)!,
            statusCode: 200,
            headers: ["Content-Type": "application/json"]
        )
    }
    
    lazy var todayClaimsFullResponse: OHHTTPStubsResponseBlock = { _ in
        return OHHTTPStubsResponse(
            fileAtPath: OHPathForFile("users.json", type(of: self))!,
            statusCode: 200,
            headers: ["Content-Type": "application/json"]
        )
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    
    func test_getTodayClaims_requestDataFromServer() {
        var executedRequests  = [URLRequest]()
        
        OHHTTPStubs.onStubActivation { (request, _, _) in
            executedRequests.append(request)
        }
        
        stub(condition: OHHTTPStubs.anyRequest(), response: todayClaimsEmptyResponse)
        
        expectWithCallbacks(description: "requestsDataFromServer") { (expectation) in
            donutsAPI.getTodayClaims { users in
                XCTAssertEqual(1, executedRequests.count)
                
                let request = executedRequests.first
                let expectedURL = "https://donuts.example.com/api/v1/claims/today"
                
                XCTAssertEqual(expectedURL, request?.url?.absoluteString)
                XCTAssertEqual("GET", request?.httpMethod)
                
                expectation.fulfill()
            }
        }
    }
    
    func test_getTodayClaims_whenNoClaimsOnServer_returnsEmptyUserList() {
        stub(condition: OHHTTPStubs.anyRequest(), response: todayClaimsEmptyResponse)
        
        expectWithCallbacks(description: "emptyClaims") { (expectation) in
            donutsAPI.getTodayClaims { users in
                XCTAssertTrue(users.isEmpty)
                expectation.fulfill()
            }
        }
    }
    
    func test_getTodayClaims_withClaimsOnServer_returnsListOfThoseUsers() {
        expectWithCallbacks(description: "claimsOnServer") { (expectation) in
            stub(condition: OHHTTPStubs.anyRequest(), response: todayClaimsFullResponse)
            
            donutsAPI.getTodayClaims { users in
                XCTAssertEqual(2, users.count)
                XCTAssertEqual(TestUsers.users, users)
                // Raninto issue w/ this:
                // /Users/manlycode/git/collectiveidea/donuts-ios/Donuts-iOS/Donuts-iOSTests/DonutsAPITest.swift:102:17: Cannot invoke 'XCTAssertEqual' with an argument list of type '([User], ([User]))'
                expectation.fulfill()
            }
        }
    }
}
