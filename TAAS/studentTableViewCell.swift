//
//  studentTableViewCell.swift
//  TAAS
//
//  Created by SABYASACHI POLLEY on 24/11/16.
//  Copyright © 2016 SR. All rights reserved.
//

import UIKit

class studentTableViewCell: UITableViewCell {
    @IBOutlet var segment : UISegmentedControl?

    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func segmentChange(segment:UISegmentedControl){
        if segment.selectedSegmentIndex == 0{
           NSNotificationCenter.defaultCenter().postNotificationName("reloadForStudent", object: nil)
        }else{
            NSNotificationCenter.defaultCenter().postNotificationName("reloadForTeacher", object: nil)
        }
    }

}
