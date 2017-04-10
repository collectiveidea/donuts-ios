//
//  DonutsAPI.swift
//  Donuts-iOS
//
//  Created by Chris Rittersdorf on 4/10/17.
//  Copyright © 2017 Collective Idea. All rights reserved.
//

import Alamofire

class DonutsAPI {
    func getTodayClaims(_ completion: @escaping ([User]) ->()) {
        let url = "https://donuts.test/api/v1/claims/today"
        
        Alamofire.request(url).responseJSON { (response) in
            completion([User]())
        }
    }
}

