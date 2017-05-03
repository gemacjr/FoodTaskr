//
//  TrayViewCell.swift
//  FoodTakr
//
//  Created by Ed McCormic on 5/1/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import UIKit

class TrayViewCell: UITableViewCell {
    
    @IBOutlet weak var lbQty: UILabel!
    @IBOutlet weak var lbMealName: UILabel!
    @IBOutlet weak var lbSubTotal: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        lbQty.layer.borderColor = UIColor.gray.cgColor
        lbQty.layer.borderWidth = 1.0
        lbQty.layer.cornerRadius = 10
    }

}
