//
//  ViewController.swift
//  TAAS
//
//  Created by SABYASACHI POLLEY on 16/11/16.
//  Copyright © 2016 SR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Scrollview that holds the Background Image
    @IBOutlet var scroll : UIScrollView?
    
    //Background Image View
    @IBOutlet var imgBGView : UIImageView?
    var lastX = 0
    var goRight = true
    override func viewDidLoad() {
        super.viewDidLoad()
        let height = self.view.frame.size.height
        let width = self.view.frame.size.width
        scroll?.contentSize = CGSizeMake(2*width, height)
       // imgBGView?.frame = CGRectMake(0, 0, 2*width, height)
       // NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector(animateBackgroundView()), userInfo: nil, repeats: true)
        let timer = NSTimer.scheduledTimerWithTimeInterval( 0.1, target: self, selector: #selector(self.animateBackgroundView), userInfo: nil, repeats: true);
        timer.fire()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Animation for moving image
    func animateBackgroundView(){
        let width = self.view.frame.size.width
        scroll!.setContentOffset(CGPoint(x:lastX, y: 0), animated: true)
        if goRight == true{
        lastX += 1
            if lastX == Int(width) {
                goRight = false
            }
        }
        else{
            lastX -= 1
            if lastX == 0 {
                goRight = true
            }
        }
        
    }

}

