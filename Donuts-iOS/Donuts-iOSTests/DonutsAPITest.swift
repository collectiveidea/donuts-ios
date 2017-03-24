//
//  DonutsAPITest.swift
//  Donuts-iOS
//
//  Created by Josh Kovach on 3/22/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import XCTest
@testable import Donuts_iOS
import OHHTTPStubs

class DonutsAPITest: XCTestCase {
  let donutsApi = DonutsAPI()

  let todayClaimsEmptyResponse: OHHTTPStubsResponseBlock = { _ in
    return OHHTTPStubsResponse(
      data: "[]".data(using: String.Encoding.utf8)!, // Empty JSON string
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

  override func tearDown() {
    OHHTTPStubs.removeAllStubs()
    super.tearDown()
  }

  func test_getTodayClaims_whenNoClaimsOnServer_callsCompletionWithUsersEmptyList() {
    expectWithCallbacks(description: "emptyClaims") { expectation in
      donutsApi.getTodayClaims { users in
        XCTAssertTrue(users.isEmpty)
        expectation.fulfill()
      }
    }
  }

  func test_getTodayClaims_withClaimsOnServer_callsCompletionWithListOfThoseUsers() {
    expectWithCallbacks(description: "fullClaims") { expectation in
      stub(condition: OHHTTPStubs.anyRequest(), response: todayClaimsFullResponse)

      donutsApi.getTodayClaims { users in
        XCTAssertEqual(TestUsers.users, users, "Users do not match Test Data")

        expectation.fulfill()
      }
    }
  }

  func test_getTodayClaims_requestsDataFromServer() {
    expectWithCallbacks(description: "requestsDataFromServer") { expectation in
      var executedRequests = [URLRequest]()
      OHHTTPStubs.onStubActivation { (request, _, _) in
        executedRequests.append(request)
      }

      stub(condition: OHHTTPStubs.anyRequest(), response: todayClaimsEmptyResponse)

      donutsApi.getTodayClaims { users in
        XCTAssertEqual(1, executedRequests.count)

        let request = executedRequests.first
        let expectedURL = "https://donuts.test/api/v1/claims/today"
        XCTAssertEqual(expectedURL, request?.url?.absoluteString)
        XCTAssertEqual("GET", request?.httpMethod)

        expectation.fulfill()
      }
    }
  }
}

struct TestUsers {
  // these users use the same values that are in the users.json

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

  static let users = [user1, user2]
}

import Alamofire

class DonutsAPI {
  func getTodayClaims(completion: @escaping ([User]) -> Void) {
    let url = "https://donuts.test/api/v1/claims/today"
    Alamofire.request(url).responseJSON { (response) in
      completion([User]())
    }
  }
}
