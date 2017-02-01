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
    var baseUrl: URL
    
    init(baseUrl: String) {
        self.baseUrl = URL(string: baseUrl)!
    }
    
    func getTodayClaims(completion: @escaping ([User]) -> ()) {
        let url = baseUrl.appendingPathComponent("/api/v1/claims/today")
        
        Alamofire.request(url).responseJSON { (response) in
            if let json = response.result.value as? [[String:Any?]] {
                let users = json.map{ User(fromJSON: $0) }
                completion(users)
            } else {
                completion([User]())
            }
        }
    }
}
