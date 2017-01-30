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

  let anyRequest: OHHTTPStubsTestBlock = { _ in return true }
  let isTodayClaims: OHHTTPStubsTestBlock = isPath("/api/v1/claims/today") && isMethodGET()

  func expectWithCallbacks(description: String, function: (_ expectation: XCTestExpectation) -> Void) {
    let asyncExpectation = expectation(description: description)

    function(asyncExpectation)

    waitForExpectations(timeout: 1) { (error) in
      if let error = error {
        XCTFail("\(description) Timeout errored: \(error)")
      }
    }
  }

  let todayClaimsEmptyResponse: OHHTTPStubsResponseBlock = { _ in
    // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
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

    expectWithCallbacks(description: "getTodayClaims()") { expectation in
      var executedRequests = [URLRequest]()

      stub(condition: anyRequest, response: todayClaimsEmptyResponse)

      OHHTTPStubs.onStubActivation { (request, _, _) in
        executedRequests.append(request)
      }

      donutsApi.getTodayClaims { _ in
        XCTAssertEqual(1, executedRequests.count)

        let request = executedRequests.first!

        XCTAssertEqual("https://donuts.test/api/v1/claims/today", request.url?.absoluteString)
        XCTAssertEqual("GET", request.httpMethod)
        
        expectation.fulfill()
      }

    }
  }

  func test_getTodayClaims_whenNoClaimsOnServer_returnsEmptyUserList() {
    let donutsApi = DonutsAPI(baseUrl: "https://donuts.test)")

    expectWithCallbacks(description: "emptyClaims") { expectation in
      stub(condition: isTodayClaims, response: todayClaimsEmptyResponse)

      donutsApi.getTodayClaims { users in
        XCTAssertTrue(users.isEmpty)
        expectation.fulfill()
      }
    }
  }

  func test_getTodayClaims_withClaimsOnServer_returnsListOfThoseUsers() {
    let donutsApi = DonutsAPI(baseUrl: "https://donuts.test")

    expectWithCallbacks(description: "fullClaims") { expectation in
      stub(condition: isTodayClaims, response: todayClaimsFullResponse)

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

