//
//  XCTestCase+Extensions.swift
//  Donuts-iOS
//
//  Created by Chris Rittersdorf on 4/10/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import XCTest

func fixtureJson(name: String) -> [String: Any]? {
    if let path = Bundle(for: UserTest.self).path(forResource: name, ofType: "json") {
        if let data = try? Data(referencing: NSData(contentsOfFile: path)) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            } catch {
                XCTFail("\(error.localizedDescription)")
            }
        }
    }
    
    return nil
}
