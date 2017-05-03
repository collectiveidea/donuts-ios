//
//  DonutsAPI.swift
//  Donuts-iOS
//
//  Created by Chris Rittersdorf on 4/10/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import Alamofire

class DonutsAPI {
    var baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func getTodayClaims(_ completion: @escaping ([User]) ->()) {
        let url = "\(baseURL)/api/v1/claims/today"
        
        Alamofire.request(url).responseJSON { (response) in
            if let json = response.result.value as? [[String: Any]] {
                let users = json.map { User(fromJSON: $0) }
                completion(users)
            } else {
                completion([User]())
            }
        }
    }
}

