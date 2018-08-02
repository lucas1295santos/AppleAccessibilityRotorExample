//
//  IceCreamTableViewCell.swift
//  RotorTests
//
//  Created by Lucas Santos on 28/07/18.
//  Copyright © 2018 Lucas Santos. All rights reserved.
//

import UIKit

class IceCreamTableViewCell: UITableViewCell {

    @IBOutlet weak var flavorLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
