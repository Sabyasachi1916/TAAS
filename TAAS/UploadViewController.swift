//
//  UploadViewController.swift
//  TAAS
//
//  Created by SABYASACHI POLLEY on 03/12/16.
//  Copyright © 2016 SR. All rights reserved.
//

import UIKit
import RealmSwift

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,setQuestionProtocol {
    
    @IBOutlet var profileImg : UIImageView!
    @IBOutlet var lblName :UILabel!
    @IBOutlet var lblUserType :UILabel!
    @IBOutlet var lblSubject :UILabel!
    @IBOutlet var lblQuestion :UILabel!
    @IBOutlet var lblStatus :UILabel!
    @IBOutlet var scroll : UIScrollView!
    let realm = try! Realm()
    var dictQuestionList : NSDictionary?
    var picker : UIImagePickerController? = nil
    var imgArray = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = realm.objects(USER.self)
        let imgString = (user[0].image)
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let imgPath = documentsDirectory.stringByAppendingPathComponent("profilePic.png")
        
        if NSFileManager.defaultManager().fileExistsAtPath(imgPath){
            self.profileImg.image = UIImage(contentsOfFile: imgPath)
        }else{
            self.profileImg.imageFromUrl(imgString, imagePath: imgPath)
        }
        self.lblName.text = user[0].first_name.capitalizedString +  " " + user[0].last_name.capitalizedString
        self.lblUserType.text = user[0].user_type.capitalizedString
        self.profileImg.layer.borderColor = UIColor.whiteColor().CGColor
        self.profileImg.layer.borderWidth = 1
       
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
   @IBAction func selectSubject(){
        let action = UIAlertController(title: "Select Subject", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        action.addAction(UIAlertAction(title: "Physics", style: .Default, handler: {_ in
           self.lblSubject.text = "Physics"
            self.getListOfQuestions()
        }))
        action.addAction(UIAlertAction(title: "Chemistry", style: .Default, handler: {_ in
            self.lblSubject.text = "Chemistry"
            self.getListOfQuestions()
        }))
        action.addAction(UIAlertAction(title: "Mathematics", style: .Default, handler: {_ in
            self.lblSubject.text = "Mathematics"
            self.getListOfQuestions()
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {_ in
        
    }))
        self.presentViewController(action, animated: true, completion: nil)
    }
    
    
    
    @IBAction func selectStatus(){
        let action = UIAlertController(title: "Select Subject", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        action.addAction(UIAlertAction(title: "Solved", style: .Default, handler: {_ in
            self.lblStatus.text = "Solved"
            
        }))
        action.addAction(UIAlertAction(title: "Cancelled", style: .Default, handler: {_ in
            self.lblStatus.text = "Cancelled"
            
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {_ in
            
        }))
        self.presentViewController(action, animated: true, completion: nil)
    }
    
@IBAction func selectQuestion(){
    if self.dictQuestionList?.valueForKeyPath("data") != nil {
       let arr = self.dictQuestionList?.valueForKeyPath("data")! as! NSArray
       let questionVc = self.storyboard?.instantiateViewControllerWithIdentifier("QuestionListViewController") as! QuestionListViewController
    questionVc.delegate = self
        questionVc.listArrData = arr
        self.navigationController?.showViewController(questionVc, sender: self)
    }
    }
func setQuestion(str: String)
{
        self.lblQuestion.text = str
}
    
    func getListOfQuestions()
    {
        let headers = [
            "cache-control": "no-cache"
        ]
        let user = realm.objects(USER)
        let user_id = (user[0].user_id)
        print(lblSubject.text)
        let request = NSMutableURLRequest(URL: NSURL(string: "https://urtaas.com/app_control/get_email_list?user_id=\(user_id)&subject=\(lblSubject.text!)&start=0&count=10")!,
                                          cachePolicy: .UseProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                do{
                self.dictQuestionList = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    print(self.dictQuestionList)
                    if Int((self.dictQuestionList?.valueForKey("total_count"))! as! NSNumber)  == 0 {
                      API.showAlert(self, title: "Sorry!", msg: "There are no questions")
                    }
                    else{
                        let arr = self.dictQuestionList?.valueForKeyPath("data")! as! NSArray
                        let dict = arr[0] as! NSDictionary
                        print(String(dict.valueForKey("description")!))
                        dispatch_async(dispatch_get_main_queue()) {
                            self.lblQuestion.text = String(dict.valueForKey("description")!)
                        }
                        
                    }
                }catch{
                    print("Error")
                }
            }
        })
        dataTask.resume()
    }
    @IBAction func chooseProfilePicBtnClicked(sender: AnyObject) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        picker = UIImagePickerController()
        picker!.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertView()
            alert.title = "Warning"
            alert.message = "You don't have camera"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    func openGallary(){
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(picker!, animated: true, completion: nil)
    }
    //MARK:UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if imgArray.count <= 5{
            imgArray.append(pickedImage)
            }
            var x = CGFloat(0)
            for img in imgArray{
                let imgvw = UIImageView(frame: CGRectMake(x+2, 2, self.scroll.frame.height - 2, self.scroll.frame.height - 2))
                imgvw.image = img
                imgvw.contentMode = .ScaleAspectFit
                x += self.scroll.frame.height + 10
                scroll.addSubview(imgvw)
                imgvw.layer.shadowColor = UIColor.blackColor().CGColor
                imgvw.layer.shadowOffset = CGSizeMake(2, 2)
                imgvw.layer.shadowRadius = 5
                imgvw.layer.shadowOpacity = 0.5
                scroll.contentSize = CGSizeMake(x, self.scroll.frame.height)
            }
        }
        picker .dismissViewControllerAnimated(true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        print("picker cancel.")
        picker .dismissViewControllerAnimated(true, completion: nil)
    }

}
