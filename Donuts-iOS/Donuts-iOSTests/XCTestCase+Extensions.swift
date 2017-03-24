//
//  XCTestCase+Extensions.swift
//  Donuts-iOS
//
//  Created by Josh Kovach on 3/22/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import XCTest
import Foundation

extension XCTestCase {
  func fixtureJson(name: String) -> [String: Any]? {
    // Find json file with the given name from the main bundle.
    if let path = Bundle(for: UserTest.self).path(forResource: name, ofType: "json") {
      // Convert the path of the file to a Data object so we can convert it to JSON.
      if let data = try? Data(referencing: NSData(contentsOfFile: path)) {
        // Serialize the data into JSON and handle some basic errors.
        do {
          return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        } catch {
          XCTFail("\(error.localizedDescription)")
        }
      }
    } else {
      XCTFail("Can't find the test JSON file")
    }
    return nil
  }

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
