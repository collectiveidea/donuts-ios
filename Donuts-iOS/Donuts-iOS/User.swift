//
//  User.swift
//  Donuts-iOS
//
//  Created by Ben Lambert on 1/26/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import Foundation

struct User: Equatable {
    
    var id: String?
    var githubLogin: String?
    var name: String?
    var displayName: String?
    
    static func ==(lhs: User, rhs: User) -> Bool {
        if (lhs.id == rhs.id &&
            lhs.githubLogin == rhs.githubLogin &&
            lhs.name == rhs.name &&
            lhs.displayName == rhs.displayName) {
            return true
        }
        return false
    }
    
    init(fromJSON json: [String: Any]) {
        let id = json["id"] as? String
        let githubLogin = json["github_login"] as? String
        let name = json["name"] as? String
        let displayName = json["display_name"] as? String
        
        self.init(id: id, githubLogin: githubLogin, name: name, displayName: displayName)
    }
    
    init(id: String?, githubLogin: String?, name: String?, displayName: String?) {
        self.id = id
        self.githubLogin = githubLogin
        self.name = name
        self.displayName = displayName
    }
    
}
