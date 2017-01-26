//
//  DonutsAPI.swift
//  Donuts-iOS
//
//  Created by Ben Lambert on 1/26/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import Foundation
import Alamofire

struct DonutsAPI {
    let baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func urlFor(path: String) -> String {
        return "\(baseUrl)/api/v1/\(path)"
    }
    
    func getTodayClaims(completion: @escaping ([User]) -> ()) {
        Alamofire.request(urlFor(path: "claims/today")).responseJSON { (response) in
            if let json = response.result.value as? [[String:Any?]] {
                let users = json.flatMap { User(fromJSON: $0) }
                completion(users)
            } else {
                completion([User]())
            }
        }
    }
}
