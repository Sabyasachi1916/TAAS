//
//  DetailsViewController.swift
//  TAAS
//
//  Created by SABYASACHI POLLEY on 06/12/16.
//  Copyright © 2016 SR. All rights reserved.
//

import UIKit
import RealmSwift

class DetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tbl : UITableView!
    var problemID : String = ""
    var questionDetails = ""
    var answerDetails = ""
    var questionAttachment : [String] = []
    var answerAttachment : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        let user = realm.objects(USER)
        let user_id = (user[0].user_id)
        self.getQuestionDetails(problemID, userID: user_id)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("QuestionTableViewCell", forIndexPath: indexPath) as! QuestionTableViewCell
            cell.lblQuestionDetails.text = self.questionDetails
            cell.lblAttachment.text = "Attached Files(\(String(self.questionAttachment.count)))"
            if self.questionAttachment.count > 0 {
                var x = CGFloat(0)
                for url in self.questionAttachment {
                    
                    let btn = UIButton(frame: CGRectMake(x,0,100,26))
                    btn.setTitle("  Problem File \(self.questionAttachment.indexOf(url)!+1)  ", forState: UIControlState.Normal)
                    cell.scroll.addSubview(btn)
                    btn.backgroundColor = UIColor(red: 44/255.0, green: 47/255.0, blue: 95/255.0, alpha: 1)
                    btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    btn.titleLabel?.font = UIFont(name: "Helvetica", size: 13)
                    btn.layer.cornerRadius = 13
                    btn.sizeToFit()
                    x += btn.frame.width
                    x += 10
                }
                cell.scroll.contentSize = CGSizeMake(x, cell.scroll.frame.height)
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("AnswerTableViewCell", forIndexPath: indexPath) as! AnswerTableViewCell
            cell.lblAnswerDetails.text = self.answerDetails
            if cell.lblAnswerDetails.text?.rangeOfString("Question is not solved yet.") != nil {
                cell.lblAttachment.hidden = true
                cell.vwUpload.hidden = false
            }
            else{
                cell.vwUpload.hidden = true
            }
            print(self.answerAttachment)
            cell.lblAttachment.text = "Attached Files(\(String(self.answerAttachment.count)))"
            if self.answerAttachment.count > 0 {
                var x = CGFloat(0)
                for url in self.answerAttachment {
                    let btn = UIButton(frame: CGRectMake(x,0,100,26))
                    btn.setTitle("  Problem File \(self.answerAttachment.indexOf(url)!+1)  ", forState: UIControlState.Normal)
                    cell.scroll.addSubview(btn)
                    btn.backgroundColor = UIColor(red: 44/255.0, green: 47/255.0, blue: 95/255.0, alpha: 1)
                    btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    btn.titleLabel?.font = UIFont(name: "Helvetica", size: 13)
                    btn.layer.cornerRadius = 13
                    btn.sizeToFit()
                    x += btn.frame.width
                    x += 10
                }
                cell.scroll.contentSize = CGSizeMake(x, cell.scroll.frame.height)
            }
            return cell
        }
    }
   func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
   {
    if indexPath.row == 0{
        let font = UIFont(name: "Helvetica", size: 14.0)
        let height = heightForView(self.questionDetails, font: font!, width: tableView.frame.width-42)
        let calculated = 29+height+21+30 + 18
        return CGFloat(calculated)
    }
    if indexPath.row == 1{
        let font = UIFont(name: "Helvetica", size: 14.0)
        let height = heightForView(self.answerDetails, font: font!, width: tableView.frame.width-42)
        let calculated = 29+height+21+30 + 28
        return CGFloat(calculated)
    }
    return 0
    }
    func getQuestionDetails(problemID:String,userID:String){
        let headers = [
            "cache-control": "no-cache"
        ]
        print("https://urtaas.com/app_control/question_details?problem_id=\(problemID)6&user_id=\(userID)")
        let request = NSMutableURLRequest(URL: NSURL(string: "https://urtaas.com/app_control/question_details?problem_id=\(problemID)&user_id=\(userID)")!,
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
               let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                print(json)
                    dispatch_async(dispatch_get_main_queue()) {
                    self.handleResult(json)
                    }
            
                }catch{
                    print("error in parsing")
                }
            }
        })
        
        dataTask.resume()
    }
    
    func handleResult (dictData:NSDictionary){
        if dictData.valueForKeyPath("question_details.subject") != nil {
            let subject = dictData.valueForKeyPath("question_details.subject") as! String
            let questionTitle = dictData.valueForKeyPath("question_details.question_title") as! String
            let desc = dictData.valueForKeyPath("question_details.question_desc") as! String
            let date = dictData.valueForKeyPath("question_details.email_date") as! String
            self.questionDetails = "Question ID : \(self.problemID) Subject : \(subject)\nQuestion Title : \(questionTitle)\nDescription : \(desc)\nPosted on \(date)"
            self.questionAttachment = dictData.valueForKeyPath("question_details.attachment") as! [String]
           
        }
        if dictData.valueForKeyPath("solution_details.tutor_name")?.count != 0{
            print(dictData.valueForKeyPath("solution_details.tutor_name"))
            let teacher = dictData.valueForKeyPath("solution_details.tutor_name") as! String
            let comment = dictData.valueForKeyPath("solution_details.tutor_comment") as! String
            let uploaded = dictData.valueForKeyPath("solution_details.uploaded_on") as! String
            let assigndate = dictData.valueForKeyPath("question_details.assign_date") as! String
            self.answerDetails = "Assign to \(teacher) on \(assigndate)\nSolution uploaded on \(uploaded)\nReply : \(comment)"
            self.answerAttachment = dictData.valueForKeyPath("solution_details.sol_attachment.file") as! [String]
          }
        else{
            let teacher = dictData.valueForKeyPath("question_details.assigned_teacher") as! String
            let assigndate = dictData.valueForKeyPath("question_details.assign_date") as! String
            self.answerDetails = "Assign to \(teacher) on \(assigndate)\nQuestion is not solved yet."
            
        }
         self.tbl.reloadData()
 
    }
   
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
  @IBAction  func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
