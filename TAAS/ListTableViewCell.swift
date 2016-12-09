//
//  ListTableViewCell.swift
//  TAAS
//
//  Created by SABYASACHI POLLEY on 04/12/16.
//  Copyright © 2016 SR. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblSubtitle : UILabel!
    @IBOutlet weak var btnA : UIButton!
    @IBOutlet weak var btnS :UIButton!
    @IBOutlet weak var btnAccept : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
