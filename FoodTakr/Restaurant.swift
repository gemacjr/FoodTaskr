//
//  Restaurant.swift
//  FoodTakr
//
//  Created by Ed McCormic on 5/1/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import Foundation
import SwiftyJSON


class Restaurant {
    
    var id: Int?
    var name: String?
    var address: String?
    var logo: String?
    
    
    init(json: JSON) {
        self.id = json["id"].int
        self.name = json["name"].string
        self.address = json["address"].string
        self.logo = json["logo"].string
        
    }
}
