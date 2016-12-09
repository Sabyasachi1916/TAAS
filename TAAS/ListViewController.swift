//
//  ListViewController.swift
//  TAAS
//
//  Created by SABYASACHI POLLEY on 04/12/16.
//  Copyright © 2016 SR. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UIPopoverPresentationControllerDelegate {
    let realm = try! Realm()
    @IBOutlet var profileImg : UIImageView!
    @IBOutlet var lblName :UILabel!
    @IBOutlet var lblUserType :UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var btnPhysics: UIButton!
    @IBOutlet var btnChemistry: UIButton!
    @IBOutlet var btnMathematics: UIButton!
    var userId = ""
    var searchBY = "by_id"
    var allDataDict = NSDictionary()
    var arrTableData = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let user = realm.objects(USER.self)
        let imgString = (user[0].image)
        self.userId = user[0].user_id
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
        self.getQuestions("physics",search_by: self.searchBY)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func getQuestions(subject: String, search_by: String ){
       let vw = API.showActivityIndicator(self)
        let headers = [
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://urtaas.com/app_control/search_question?subject=\(subject)&user_id=\(self.userId)&search_key=10001&search_filter=\(search_by)&start=0&count=10&status=N")!,
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
                    self.allDataDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    print(self.allDataDict["data"]?.count)
                    self.arrTableData = self.allDataDict["data"] as! NSArray
                    dispatch_async(dispatch_get_main_queue()) {
                    self.tblView.reloadData()
                    }
                    
                    }
                    catch{
                    print("Error")
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                vw.removeFromSuperview()
            }
            
        })
        
        dataTask.resume()
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellList") as! ListTableViewCell
        print(arrTableData[indexPath.row])
        cell.lblTitle.text = arrTableData[indexPath.row].valueForKey("title")! as? String
        let index2 = (arrTableData[indexPath.row].valueForKey("uploaded_on")! as! String).startIndex.advancedBy(10)
        let strDate = arrTableData[indexPath.row].valueForKey("uploaded_on")! as! String
        let strGrade = arrTableData[indexPath.row].valueForKey("grade")! as! String
        cell.lblSubtitle.text = "Posted on \(strDate.substringToIndex(index2)) of Grade \(strGrade)"
        let dateA = arrTableData[indexPath.row].valueForKey("assign_date")! as! String
        cell.btnA.setTitle(" A:\(dateA.substringToIndex(index2)) ", forState: UIControlState.Normal)
        cell.btnA.sizeToFit()
        let dateS = arrTableData[indexPath.row].valueForKey("date")! as! String
        cell.btnS.setTitle(" S:\(dateS.substringToIndex(index2)) ", forState: UIControlState.Normal)
        cell.btnS.sizeToFit()
        print(arrTableData[indexPath.row].valueForKey("is_viewed")! as! String)
        if arrTableData[indexPath.row].valueForKey("is_viewed")! as! String != "0"{
        cell.btnAccept.setTitle(" Accepted ", forState: UIControlState.Normal)
        }else{
            cell.btnAccept.setTitle(" Not Accepted ", forState: UIControlState.Normal)
            cell.btnAccept.backgroundColor = UIColor.redColor()
        }
        cell.btnAccept.sizeToFit()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    @IBAction func PhysicsTapped (){
      self.getQuestions("physics",search_by: self.searchBY)
        btnPhysics.backgroundColor = UIColor.lightGrayColor()
        btnChemistry.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 69/255.0, alpha: 0.76)
        btnMathematics.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 69/255.0, alpha: 0.76)
    }
    @IBAction func ChemistryTapped (){
     self.getQuestions("chemistry",search_by: self.searchBY)
        btnPhysics.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 69/255.0, alpha: 0.76)
        btnChemistry.backgroundColor = UIColor.lightGrayColor()
        btnMathematics.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 69/255.0, alpha: 0.76)
    }
    @IBAction func MathTapped (){
      self.getQuestions("mathematics",search_by: self.searchBY)
        btnPhysics.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 69/255.0, alpha: 0.76)
        btnChemistry.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 69/255.0, alpha: 0.76)
        btnMathematics.backgroundColor = UIColor.lightGrayColor()
    }
    
    @IBAction func selectSearchType(){
        let action = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        action.addAction(UIAlertAction(title: "Search by Question Title", style: .Default, handler: {_ in
            self.searchBY = "by_title"
        }))
        action.addAction(UIAlertAction(title: "Search by Question ID", style: .Default, handler: {_ in
            self.searchBY = "by_id"
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {_ in
            
        }))
        self.presentViewController(action, animated: true, completion: nil)
    }
    
    @IBAction func addPopOver(sender:UIButton){
        performSegueWithIdentifier("popoverInfo", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverInfo" {
            let popoverViewController = segue.destinationViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.preferredContentSize = CGSizeMake(150, 200)
        }

    }
        func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.None
        }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let teacher = self.storyboard?.instantiateViewControllerWithIdentifier("DetailsViewController") as! DetailsViewController
        teacher.problemID = arrTableData[indexPath.row].valueForKey("question_id")! as! String
        self.navigationController?.pushViewController(teacher, animated: true)
    }
    
    
    
    
    
    
    
    
    
}
