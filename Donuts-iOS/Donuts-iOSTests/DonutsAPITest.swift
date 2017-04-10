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

class DonutsAPITest: XCTestCase {
    let donutsAPI = DonutsAPI()
    let todayClaimsEmptyResponse: OHHTTPStubsResponseBlock = { _ in
        return OHHTTPStubsResponse(
            data: "[]".data(using: String.Encoding.utf8)!,
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
                XCTAssertEqual("https://donuts.test/api/v1/claims/today", request?.url?.absoluteString)
                XCTAssertEqual("GET", request?.httpMethod)
                
                expectation.fulfill()
            }
        }
    }
    
    func test_getTodayClaims_whenNoClaimsOnServer_returnsEmptyUserList() {
        
        expectWithCallbacks(description: "emptyClaims") { (expectation) in
            donutsAPI.getTodayClaims { users in
                XCTAssertTrue(users.isEmpty)
                expectation.fulfill()
            }
        }
    }
}
