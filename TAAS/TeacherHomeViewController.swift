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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
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
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
//    {
//        var title = ""
//        switch section {
//        case 0:
//            title = "New Problems"
//        case 1:
//            title = "Solved Problems"
//        case 2:
//            title = "Assigned Problems"
//        default:
//            title = "Cancelled Problems"
//        }
//        return title
//    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 12
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Mathematics"
        case 1:
            cell.textLabel?.text = "Physics"
        case 2:
            cell.textLabel?.text = "Chemistry"
        default:
            cell.textLabel?.text = "Mathematics"
        }
        return cell
    }

}
