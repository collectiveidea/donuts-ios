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

  override func tearDown() {
    OHHTTPStubs.removeAllStubs()
    super.tearDown()
  }

  let todayClaimsEmptyResponse: OHHTTPStubsResponseBlock = { _ in
    return OHHTTPStubsResponse(
      data: "[]".data(using: String.Encoding.utf8)!, // Empty JSON string
      statusCode: 200,
      headers: ["Content-Type": "application/json"]
    )
  }
  func test_getTodayClaims_whenNoClaimsOnServer_callsCompletionWithUsersList() {
    expectWithCallbacks(description: "emptyClaims") { expectation in
      donutsApi.getTodayClaims { users in
        XCTAssertTrue(users.isEmpty)
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

        expectation.fulfill()
      }
    }
  }
}


class DonutsAPI {
  func getTodayClaims(completion: ([User]) -> Void) {
    completion([User]())
  }
}
