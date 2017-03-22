//
//  OHHTTPStubs+Extensions.swift
//  Donuts-iOS
//
//  Created by Josh Kovach on 3/22/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import OHHTTPStubs

extension OHHTTPStubs {
  static func anyRequest() -> OHHTTPStubsTestBlock {
    return { _ in return true }
  }
}
