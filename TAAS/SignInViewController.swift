//
//  SignInViewController.swift
//  TAAS
//
//  Created by SABYASACHI POLLEY on 16/11/16.
//  Copyright © 2016 SR. All rights reserved.
//
import RealmSwift
import UIKit
class USER: Object {
    dynamic var first_name = ""
    dynamic var last_name = ""
    dynamic var user_id = ""
    dynamic var user_name = ""
    dynamic var user_type = ""
    dynamic var image = ""
    dynamic var expertise = ""
    dynamic var email = ""
    dynamic var degree = ""
    dynamic var country = ""
    dynamic var city = ""
    dynamic var address1 = ""
    dynamic var address2 = ""
}
class SignInViewController: UIViewController ,UITextFieldDelegate{
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPass: UITextField!
    //Scrollview that holds the Background Image
    @IBOutlet var scroll : UIScrollView?
    
    //Background Image View
    @IBOutlet var imgBGView : UIImageView?
    var lastX = 0
    var goRight = true
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
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        let height = self.view.frame.size.height
        let width = self.view.frame.size.width
        scroll?.contentSize = CGSizeMake(2*width, height)
        // imgBGView?.frame = CGRectMake(0, 0, 2*width, height)
        // NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector(animateBackgroundView()), userInfo: nil, repeats: true)
        let timer = NSTimer.scheduledTimerWithTimeInterval( 0.1, target: self, selector: #selector(self.animateBackgroundView), userInfo: nil, repeats: true);
        timer.fire()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//Back from viewController 
  @IBAction func back()
    {
       self.navigationController?.popViewControllerAnimated(true)
    }
    
// Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
        }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
    
        if textField == txtEmail {
            if textField.text?.characters.count > 0{
            if self.isValidEmail(self.txtEmail.text!){
               return true
            }else{
                return false
                }
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
//Email validation
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }

    
//SignIn Pressed (Login)
@IBAction  func signInPressed()
    {
        if txtEmail.text?.characters.count == 0 {
            API.showAlert(self, title: "Alert", msg: "Please enter your email address")
            return
        }
        if txtPass.text?.characters.count == 0 {
            API.showAlert(self, title: "Alert", msg: "Please enter your password")
            return
        }
        API.login(txtEmail.text!, txtPass: self.txtPass.text!, completion: {json in
            let dictAllInfo = NSDictionary(dictionary: json as! [NSObject : AnyObject])
            print(dictAllInfo.valueForKey("status"))
            if dictAllInfo.valueForKey("status")! as! String == "SUCCESS"{
                dispatch_async(dispatch_get_main_queue()) {
                    let user = USER()
                    user.first_name = (dictAllInfo.valueForKeyPath("data.user.first_name")! as! String)
                    user.last_name = (dictAllInfo.valueForKeyPath("data.user.last_name")! as! String)
                    user.user_name = (dictAllInfo.valueForKeyPath("data.user.user_name")! as! String)
                    user.user_type = (dictAllInfo.valueForKeyPath("data.user.user_type")! as! String)
                    user.image = (dictAllInfo.valueForKeyPath("data.user.image")! as! String)
                    user.expertise = (dictAllInfo.valueForKeyPath("data.user.expertise")! as! String)
                    try! self.realm.write {
                        self.realm.add(user)
                    }
                    self.performSegueWithIdentifier("signIn", sender: self)
                }
                
            }
            
        })
    }
    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        let teacher = self.storyboard?.instantiateViewControllerWithIdentifier("TeacherHomeViewController") as! TeacherHomeViewController
        self.navigationController?.pushViewController(teacher, animated: true)
    }
    
    
    
}
