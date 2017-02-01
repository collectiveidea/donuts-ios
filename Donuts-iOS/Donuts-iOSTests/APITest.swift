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

extension XCTestCase {
    func expectWithCallbacks(description: String, function: (_ expectation: XCTestExpectation) -> Void) {
        let asyncExpectation = expectation(description: description)
        
        function(asyncExpectation)
        
        waitForExpectations(timeout: 1) { (error) in
            if let error = error {
                XCTFail("\(description) Timeout errored: \(error)")
            }
        }
    }
}

class APITest: XCTestCase {

  let donutsApi = DonutsAPI(baseUrl: "https://donuts.test")

  let anyRequest: OHHTTPStubsTestBlock = { _ in return true }

  let todayClaimsEmptyResponse: OHHTTPStubsResponseBlock = { _ in
    return OHHTTPStubsResponse(
      data: "[]".data(using: String.Encoding.utf8)!,
      statusCode: 200,
      headers: ["Content-Type": "application/json"]
    )
  }

  lazy var todayClaimsFullResponse: OHHTTPStubsResponseBlock =  { _ in
    return OHHTTPStubsResponse(
      fileAtPath: OHPathForFile("users.json", type(of: self))!,
      statusCode: 200,
      headers: ["Content-Type": "application/json"]
    )
  }

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    OHHTTPStubs.removeAllStubs()
    super.tearDown()
  }

  func test_getTodayClaims_callsNetworkApi() {
    expectWithCallbacks(description: "getTodayClaims()") { expectation in
      var executedRequests = [URLRequest]()

      stub(condition: anyRequest, response: todayClaimsEmptyResponse)

      OHHTTPStubs.onStubActivation { (request, _, _) in
        executedRequests.append(request)
      }

      donutsApi.getTodayClaims { _ in
        XCTAssertEqual(1, executedRequests.count)

        let request = executedRequests.first

        XCTAssertEqual("https://donuts.test/api/v1/claims/today", request?.url?.absoluteString)
        XCTAssertEqual("GET", request?.httpMethod)
        
        expectation.fulfill()
      }
    }
  }

  func test_getTodayClaims_whenNoClaimsOnServer_returnsEmptyUserList() {
    expectWithCallbacks(description: "emptyClaims") { expectation in
      stub(condition: anyRequest, response: todayClaimsEmptyResponse)

      donutsApi.getTodayClaims { users in
        XCTAssertTrue(users.isEmpty)
        expectation.fulfill()
      }
    }
  }

  func test_getTodayClaims_withClaimsOnServer_returnsListOfThoseUsers() {
    expectWithCallbacks(description: "fullClaims") { expectation in
      stub(condition: anyRequest, response: todayClaimsFullResponse)

      donutsApi.getTodayClaims { users in
        XCTAssertEqual(users, TestUsers.users, "Users do not match Test Data")

        expectation.fulfill()
      }
    }
  }
}

struct TestUsers {
  // these users use the same values that are in the users.json

  private static let user1 = User(
    id: "63db9251-9c45-41ca-92d6-15e84ebea5b3",
    githubLogin: "vgonda",
    name: "Victoria Gonda",
    displayName: "Victoria"
  )

  private static let user2 = User(
    id: "73db9251-9c45-41ca-92d6-15e84ebea5b3",
    githubLogin: "bebert",
    name: "Be-Bert",
    displayName: "Be-Bert"
  )
  
  static let users = [user1, user2]
}

