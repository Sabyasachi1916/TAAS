//
//  signupCell.swift
//  TAAS
//
//  Created by SABYASACHI POLLEY on 24/11/16.
//  Copyright © 2016 SR. All rights reserved.
//
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}
import UIKit

class signupCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func signUp(){
        NSNotificationCenter.defaultCenter().postNotificationName("signUp", object: nil)
    }
 
}
