//
//  textCell.swift
//  TAAS
//
//  Created by SABYASACHI POLLEY on 24/11/16.
//  Copyright © 2016 SR. All rights reserved.
//

import UIKit

class textCell: UITableViewCell {
    @IBOutlet var textField :UITextField?
    override func awakeFromNib() {
      
        //textField!.backgroundColor = UIColor.blueColor()
       // textField!.attributedPlaceholder = NSAttributedString(string:"placeholder text",
                                                              // attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
