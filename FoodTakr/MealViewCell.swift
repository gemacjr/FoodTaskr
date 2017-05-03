//
//  MealViewCell.swift
//  FoodTakr
//
//  Created by Ed McCormic on 5/1/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import UIKit

class MealViewCell: UITableViewCell {
    
    @IBOutlet weak var lbMealName: UILabel!
    @IBOutlet weak var lbMealShortDescription: UILabel!
    @IBOutlet weak var lbMealPrice: UILabel!
    
    @IBOutlet weak var imgMealImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}
