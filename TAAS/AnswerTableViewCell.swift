//
//  AnswerTableViewCell.swift
//  TAAS
//
//  Created by SABYASACHI POLLEY on 06/12/16.
//  Copyright © 2016 SR. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
@IBOutlet var lblAnswerDetails : UILabel!
    @IBOutlet var lblAttachment : UILabel!
    @IBOutlet var scroll : UIScrollView!
    @IBOutlet var  vwUpload: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}