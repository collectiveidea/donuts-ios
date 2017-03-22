//
//  DonutsAPITest.swift
//  Donuts-iOS
//
//  Created by Josh Kovach on 3/22/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import XCTest
@testable import Donuts_iOS

class DonutsAPITest: XCTestCase {
  let donutsApi = DonutsAPI()

  func test_getTodayClaims_whenNoClaimsOnServer_returnsEmptyUserList() {
    XCTAssertTrue(donutsApi.getTodayClaims().isEmpty)
  }
}


class DonutsAPI {
  func getTodayClaims() -> [User] {
    return [User]()
  }
}
