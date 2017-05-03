//
//  DriverOrderCell.swift
//  FoodTakr
//
//  Created by Ed McCormic on 5/2/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import UIKit

class DriverOrderCell: UITableViewCell {
    
    @IBOutlet weak var lbRestaurantName: UILabel!
    @IBOutlet weak var lbCustomerName: UILabel!
    @IBOutlet weak var lbCustomerAddress: UILabel!
    @IBOutlet weak var imgCustomerAvatar: UIImageView!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
