//
//  TeacherHomeViewController.swift
//  TAAS
//
//  Created by SABYASACHI POLLEY on 18/11/16.
//  Copyright © 2016 SR. All rights reserved.
//

extension UIImageView {
    public func imageFromUrl(urlString: String, imagePath : String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                    UIImageJPEGRepresentation(self.image!, 100)!.writeToFile(imagePath, atomically: true)
                }
            }
        }
    }
}


import RealmSwift
import UIKit

class TeacherHomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
let realm = try! Realm()
    @IBOutlet var profileImg : UIImageView!
    @IBOutlet var lblName :UILabel!
    @IBOutlet var lblUserType :UILabel!
    @IBOutlet var tbl : UITableView!
    var allDashBoardData : NSDictionary?
    var newTotalCount = ""
    var newPhCount = ""
    var newChCount = ""
    var newMtCount = ""
    var solvedTotalCount = ""
    var solvedPhCount = ""
    var solvedChCount = ""
    var solvedMtCount = ""
    var assignedTotalCount = ""
    var assignedPhCount = ""
    var assignedChCount = ""
    var assignedMtCount = ""
    var cancelTotalCount = ""
    var cancelPhCount = ""
    var cancelChCount = ""
    var cancelMtCount = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDashboardData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.navigateToNext(_:)), name: "HomeNavigationNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.navigateToNext(_:)), name: "UploadtionNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.navigateToNext(_:)), name: "ListViewNotification", object: nil)
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//Table View Data source
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        var title = ""
        switch section {
        case 0:
            title = "New Problems"
        case 1:
            title = "Solved Problems"
        case 2:
            title = "Assigned Problems"
        default:
            title = "Cancelled Problems"
        }
        return title
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 4
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let countText = UILabel(frame: CGRectMake(cell.contentView.frame.width-100,10,80,30))
        countText.textAlignment = NSTextAlignment.Right
        countText.textColor = UIColor.blackColor()
        countText.tag = 100
        if (cell.contentView.viewWithTag(100) != nil){
            cell.contentView.viewWithTag(100)?.removeFromSuperview()
        }
        cell.contentView.addSubview(countText)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Mathematics"
                countText.text = newMtCount
            case 1:
                cell.textLabel?.text = "Physics"
                countText.text = newPhCount
            default:
                cell.textLabel?.text = "Chemistry"
                countText.text = newChCount
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Mathematics"
                countText.text = solvedMtCount
            case 1:
                cell.textLabel?.text = "Physics"
                countText.text = solvedPhCount
            default:
                cell.textLabel?.text = "Chemistry"
                countText.text = solvedChCount
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Mathematics"
                countText.text = assignedMtCount
            case 1:
                cell.textLabel?.text = "Physics"
                countText.text = assignedPhCount
            default:
                cell.textLabel?.text = "Chemistry"
                countText.text = assignedChCount
            }
        default:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Mathematics"
                countText.text = cancelMtCount
            case 1:
                cell.textLabel?.text = "Physics"
                countText.text = cancelPhCount
            default:
                cell.textLabel?.text = "Chemistry"
                countText.text = cancelChCount
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        var withColor : UIColor?
       let vw = UIView(frame: CGRectMake(5, 5, tableView.frame.width-10, 70))
        
        let titleText = UILabel(frame: CGRectMake(20,10,vw.frame.width-100,30))
        titleText.textColor = UIColor.whiteColor()
        vw.addSubview(titleText)
        let countText = UILabel(frame: CGRectMake(vw.frame.width-100,10,80,30))
        countText.textAlignment = NSTextAlignment.Right
        countText.textColor = UIColor.whiteColor()
        vw.addSubview(countText)
        switch section {
        case 0:
            title = "New Problems"
            countText.text = newTotalCount
            withColor = UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1)
        case 1:
            title = "Solved Problems"
            countText.text = solvedTotalCount
            withColor = UIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1)
        case 2:
            title = "Assigned Problems"
            countText.text = assignedTotalCount
            withColor = UIColor(red: 155/255.0, green: 89/255.0, blue: 182/255.0, alpha: 1)
        default:
            title = "Cancelled Problems"
            countText.text = cancelTotalCount
            withColor = UIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1)
        }
        titleText.text = title
        vw.layer.cornerRadius = 5
        vw.layer.shadowColor = UIColor.grayColor().CGColor
        vw.layer.shadowOffset = CGSizeMake(2, 2)
        vw.layer.shadowRadius =  5
        vw.layer.shadowOpacity = 1
        vw.backgroundColor = withColor
        
        return vw
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    
    
    func getDashboardData(){
        let vwSpinner = API.showActivityIndicator(self)
        let headers = [
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://urtaas.com/app_control/dashboard?user_id=2&filter=show_all")!,
                                          cachePolicy: .UseProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? NSHTTPURLResponse
                print(httpResponse)
                do{
                    
                  self.allDashBoardData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    print(self.allDashBoardData!)
                    self.newTotalCount = self.allDashBoardData!.valueForKeyPath("data.new_count.total")! as! String
                    self.newPhCount = self.allDashBoardData!.valueForKeyPath("data.new_count.Physics")! as! String
                    self.newChCount = self.allDashBoardData!.valueForKeyPath("data.new_count.Chemistry")! as! String
                    self.newMtCount = self.allDashBoardData!.valueForKeyPath("data.new_count.Mathematics")! as! String
                    
                    self.solvedTotalCount = self.allDashBoardData!.valueForKeyPath("data.solved_count.total")! as! String
                    self.solvedPhCount = self.allDashBoardData!.valueForKeyPath("data.solved_count.Physics")! as! String
                    self.solvedChCount = self.allDashBoardData!.valueForKeyPath("data.solved_count.Chemistry")! as! String
                    self.solvedMtCount = self.allDashBoardData!.valueForKeyPath("data.solved_count.Mathematics")! as! String
                    
                    
                    self.assignedTotalCount = self.allDashBoardData!.valueForKeyPath("data.assigned_count.total")! as! String
                    self.assignedPhCount = self.allDashBoardData!.valueForKeyPath("data.assigned_count.Physics")! as! String
                    self.assignedChCount = self.allDashBoardData!.valueForKeyPath("data.assigned_count.Chemistry")! as! String
                    self.assignedMtCount = self.allDashBoardData!.valueForKeyPath("data.assigned_count.Mathematics")! as! String
                    
                    self.cancelTotalCount = self.allDashBoardData!.valueForKeyPath("data.cancel_count.total")! as! String
                    self.cancelPhCount = self.allDashBoardData!.valueForKeyPath("data.cancel_count.Physics")! as! String
                    self.cancelChCount = self.allDashBoardData!.valueForKeyPath("data.cancel_count.Chemistry")! as! String
                    self.cancelMtCount = self.allDashBoardData!.valueForKeyPath("data.cancel_count.Mathematics")! as! String
                    
                
                    
                }
                catch{
                   print("not a dict")
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
            self.tbl.reloadData()
            vwSpinner.removeFromSuperview()
            }
        })
        
        dataTask.resume()
    
    }
    
    func navigateToNext(sender:NSNotification) -> Void {
        if sender.name == "HomeNavigationNotification"
        {
            self.navigationController?.popToViewController(self, animated: false)
        }
        if sender.name == "UploadtionNotification"
        {
            self.navigationController?.popToViewController(self, animated: false)
        }
    }
}
