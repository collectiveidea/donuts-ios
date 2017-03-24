//
//  User.swift
//  Donuts-iOS
//
//  Created by Josh Kovach on 3/22/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import Foundation

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

extension User: Equatable {
  static func ==(lhs: User, rhs: User) -> Bool {
    return true
  }
}
