//
//  DriverOrder.swift
//  FoodTakr
//
//  Created by Ed McCormic on 5/2/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import Foundation
import SwiftyJSON


class DriverOrder {
    
    
    var id: Int?
    var customerName: String?
    var customerAddress: String?
    var customerAvatar: String?
    var restaurantName: String?
    
    init(json: JSON) {
        
        self.id = json["id"].int
        self.customerName = json["customer"]["name"].string
        self.customerAddress = json["adderss"].string
        self.customerAvatar = json["customer"]["avatar"].string
        self.restaurantName = json["restaurant"]["name"].string
        
    }
    
    
}
