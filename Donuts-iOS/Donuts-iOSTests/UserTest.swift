//
//  UserTest.swift
//  Donuts-iOS
//
//  Created by Josh Kovach on 3/22/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import XCTest

class UserTest: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testJsonMapping_returnsValidUser() {
    let json = fixtureJson(name: "user")!
    let user = User(fromJSON: json)

    XCTAssert("63db9251-9c45-41ca-92d6-15e84ebea5b3" == user.id)
    XCTAssert("be-bert" == user.githubLogin)
    XCTAssert("Be-Bert" == user.name)
    XCTAssert("Be-Bert" == user.displayName)
  }
}

struct User {
  var id: String?
  var githubLogin: String?
  var name: String?
  var displayName: String?
}

extension User {
  init(fromJSON json: [String: Any]) {
    self.init(
      id: json["id"] as? String,
      githubLogin: json["github_login"] as? String,
      name: json["name"] as? String,
      displayName: json["display_name"] as? String
    )
  }
}
