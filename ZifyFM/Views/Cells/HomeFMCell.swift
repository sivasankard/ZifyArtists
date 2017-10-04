//
//  HomeFMCell.swift
//  ZifyFM
//
//  Created by Siva Sankar on 04/10/17.
//  Copyright © 2017 Siva Sankar. All rights reserved.
//

import UIKit

class HomeFMCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var fmImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
