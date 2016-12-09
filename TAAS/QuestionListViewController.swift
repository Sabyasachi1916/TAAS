//
//  QuestionListViewController.swift
//  TAAS
//
//  Created by SABYASACHI POLLEY on 09/12/16.
//  Copyright © 2016 SR. All rights reserved.
//
protocol setQuestionProtocol
{
    func setQuestion(str: String)
}
import UIKit

class QuestionListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var listArrData : NSArray!
    var delegate : setQuestionProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.listArrData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.listArrData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let dict = self.listArrData[indexPath.row] as! NSDictionary
        print(String(dict.valueForKey("description")!))
        cell.textLabel?.text = String(dict.valueForKey("description")!)
        cell.detailTextLabel?.text = "Question id : "+String(dict.valueForKey("question_id")!)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dict = self.listArrData[indexPath.row] as! NSDictionary
        delegate.setQuestion(String(dict.valueForKey("description")!))
        self.navigationController?.popViewControllerAnimated(true)
    }
}
