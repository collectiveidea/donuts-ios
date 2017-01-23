//
//  UserTest.swift
//  Donuts-iOS
//
//  Created by Josh Kovach on 1/23/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import XCTest
import ObjectMapper

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
      let jsonString = fixtureJson(name: "user")!
      let user = User(JSONString: jsonString)!

      XCTAssert("63db9251-9c45-41ca-92d6-15e84ebea5b3" == user.id)
      XCTAssert("vgonda" == user.githubLogin)
      XCTAssert("Victoria Gonda" == user.name)
      XCTAssert("Victoria" == user.displayName)

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

  func fixtureJson(name: String) -> String? {
    if let file = Bundle(for: UserTest.self).path(forResource: name, ofType: "json") {
      return try? String.init(contentsOfFile: file)
    } else {
      XCTFail("Can't find the test JSON file")
      return nil
    }

  }

}

class User: Mappable {
  var id: String?
  var githubLogin: String?
  var name: String?
  var displayName: String?

  required init?(map: Map) {

  }

  func mapping(map: Map) {
    id <- map["id"]
    githubLogin <- map["github_login"]
    name <- map["name"]
    displayName <- map["display_name"]
  }
}
