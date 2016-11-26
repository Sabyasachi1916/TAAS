//
//  RegisterViewController.swift
//  TAAS
//
//  Created by SABYASACHI POLLEY on 23/11/16.
//  Copyright © 2016 SR. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIActionSheetDelegate {
var arrCellNames = ["First Name","Last Name","Email","Phone Number","Country","Password","Confirm Password","Student","Grade","Signup"]
    var countryList = ["Afghanistan","Albania","Algeria","Andorra","Angola","Antigua and Barbuda","Argentina","Armenia","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bhutan","Bolivia","Bosnia and Herzegovina","Botswana","Brazil","Brunei","Bulgaria","Burkina Faso","Burundi","Cabo Verde","Cambodia","Cameroon","Canada","Central African Republic (CAR)","Chad","Chile","China","Colombia","Comoros","Democratic Republic of the Congo","Republic of the Congo","Costa Rica","Cote d'Ivoire","Croatia","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia","Fiji","Finland","France","Gabon","Gambia","Georgia","Germany","Ghana","Greece","Grenada","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Honduras","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Kiribati","Kosovo","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Mauritania","Mauritius","Mexico","Micronesia","Moldova","Monaco","Mongolia","Montenegro","Morocco","Mozambique","Myanmar (Burma)","Namibia","Nauru","Nepal","Netherlands","New Zealand","Nicaragua","Niger","Nigeria","North Korea","Norway","Oman","Pakistan","Palau","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Qatar","Romania","Russia","Rwanda","Saint Kitts and Nevis","Saint Lucia","Saint Vincent and the Grenadines","Samoa","San Marino","Sao Tome and Principe","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","South Korea","South Sudan","Spain","Sri Lanka","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor-Leste","Togo","Tonga","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","Tuvalu","Uganda","Ukraine","United Arab Emirates (UAE)","United Kingdom (UK)","United States of America (USA)","Uruguay","Uzbekistan","Vanuatu","Vatican City (Holy See)","Venezuela","Vietnam","Yemen","Zambia","Zimbabwe"]
    
    var firstName = ""
    var lastName = ""
    var Email = ""
    var phNumber = ""
    var country = ""
    var password = ""
    var confirmPassword = ""
    var grade = ""
    var profession = ""
    var degree = ""
    var expertise = ""
    var arrStudent = ["","","","","","","","",""]
    var arrTeacher = ["","","","","","","","","","","",""]
    @IBOutlet var tableView :UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.loadTableViewForStudent), name: "reloadForStudent", object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.loadTableViewForTeacher), name: "reloadForTeacher", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.signup), name: "signUp", object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK: - RELOAD tableview for  student
    func loadTableViewForStudent() -> Void {
        arrCellNames = ["First Name","Last Name","Email","Phone Number","Country","Password","Confirm Password","Student","Grade","Signup"]
    tableView?.reloadData()
    }
    
    
    //MARK: - RELOAD tableview for Teacher
    func loadTableViewForTeacher() -> Void {
        arrCellNames = ["First Name","Last Name","Email","Phone Number","Country","Password","Confirm Password","Student","Profession","Degree","Expertise","Signup"]
        tableView?.reloadData()
    }
    
    
   // MARK: - TableViewDtasource and delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
    return arrCellNames.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if arrCellNames[indexPath.row] != "Country" && arrCellNames[indexPath.row] != "Student" && arrCellNames[indexPath.row] != "Signup" && arrCellNames[indexPath.row] != "Degree" && arrCellNames[indexPath.row] != "Expertise"{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath) as! textCell
            cell.textField!.placeholder = arrCellNames[indexPath.row]
            cell.textField!.attributedPlaceholder = NSAttributedString(string:arrCellNames[indexPath.row], attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            cell.textField?.tag = indexPath.row
            cell.textField?.delegate = self
            if cell.textField?.tag == 6 {
                cell.textField?.secureTextEntry = true
            }else{
                if cell.textField?.tag == 5 {
                    cell.textField?.secureTextEntry = true
                }else{
                    cell.textField?.secureTextEntry = false
                }
            }
            if cell.textField?.tag == 3{
                cell.textField?.keyboardType = UIKeyboardType.EmailAddress
            }
            if cell.textField?.tag == 4{
                cell.textField?.keyboardType = UIKeyboardType.NumbersAndPunctuation
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
            
        }else if arrCellNames[indexPath.row] == "Country" {
            
            let cell1 = tableView.dequeueReusableCellWithIdentifier("selectCell", forIndexPath: indexPath) as! selectCell
            cell1.seletLabel!.text = "select Country"
            cell1.seletTitle?.text = arrStudent[indexPath.row]
            cell1.selectionStyle = UITableViewCellSelectionStyle.None
            return cell1
            
        }
        else if arrCellNames[indexPath.row] == "Degree" {
            
            let cell1 = tableView.dequeueReusableCellWithIdentifier("selectCell", forIndexPath: indexPath) as! selectCell
            cell1.seletLabel!.text = "select Degree"
            cell1.seletTitle?.text = arrTeacher[indexPath.row]
            cell1.selectionStyle = UITableViewCellSelectionStyle.None
            return cell1
            
        }
        else if arrCellNames[indexPath.row] == "Expertise" {
            
            let cell1 = tableView.dequeueReusableCellWithIdentifier("selectCell", forIndexPath: indexPath) as! selectCell
            cell1.seletLabel!.text = "select Expertise"
            cell1.seletTitle?.text = arrTeacher[indexPath.row]
            cell1.selectionStyle = UITableViewCellSelectionStyle.None
            return cell1
            
        }
        else if arrCellNames[indexPath.row] == "Student" {
            
            let cell2 = tableView.dequeueReusableCellWithIdentifier("segmentCell", forIndexPath: indexPath) as! studentTableViewCell
            cell2.selectionStyle = UITableViewCellSelectionStyle.None
            return cell2
            
        }else{
            
            let cell3 = tableView.dequeueReusableCellWithIdentifier("signUpCell", forIndexPath: indexPath) as! signupCell
            cell3.selectionStyle = UITableViewCellSelectionStyle.None
            return cell3
            
        }
        
    }
    func removeView()
    {
        
        UIView.animateWithDuration(0.5, animations: {
            self.view.viewWithTag(200)!.frame = CGRectMake(0,self.view.frame.height,self.view.frame.width,250)
            }, completion: {(completion:Bool) in
                self.view.viewWithTag(200)!.removeFromSuperview()
                self.view.viewWithTag(100)?.removeFromSuperview()
        })
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if arrCellNames[indexPath.row] == "Country" {
            let vw = UIView(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.height))
            vw.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            self.view.addSubview(vw)
            vw.tag = 100
            let tap = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.removeView))
            vw.addGestureRecognizer(tap)
            let picker = UIPickerView(frame: CGRectMake(0,self.view.frame.height,self.view.frame.width,250) )
            picker.dataSource = self
            picker.delegate = self
            picker.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(picker)
            picker.tag = 200
            picker.layer.cornerRadius = 10
            UIView.animateWithDuration(0.5, animations: {
                picker.frame = CGRectMake(0,self.view.frame.height-250,self.view.frame.width,250)
                }, completion: nil)
            
        }
        
        if arrCellNames[indexPath.row] == "Degree" {
            let action = UIAlertController(title: "Select Degree", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            action.addAction(UIAlertAction(title: "High School (HS)", style: .Default, handler: {_ in
                self.reloadRowWithText(9, text: "High School (HS)")
            }))
            action.addAction(UIAlertAction(title: "Bachelor Of Science (BS)", style: .Default, handler: {_ in
                self.reloadRowWithText(9, text: "Bachelor Of Science (BS)")
            }))
            action.addAction(UIAlertAction(title: "Master Of Science (MS)", style: .Default, handler: {_ in
                self.reloadRowWithText(9, text: "Master Of Science (MS)")
            }))
            action.addAction(UIAlertAction(title: "Ph.D", style: .Default, handler: {_ in
                self.reloadRowWithText(9, text: "Ph.D")
            }))
            action.addAction(UIAlertAction(title: "Engineering", style: .Default, handler: {_ in
                self.reloadRowWithText(9, text: "Engineering")
            }))
            action.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {_ in
                
            }))
            self.presentViewController(action, animated: true, completion: nil)
        }
        if arrCellNames[indexPath.row] == "Expertise" {
            let action = UIAlertController(title: "Select Expertise", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            action.addAction(UIAlertAction(title: "Physics", style: .Default, handler: {_ in
               self.reloadRowWithText(10, text: "Physics")
            }))
            action.addAction(UIAlertAction(title: "Chemistry", style: .Default, handler: {_ in
                self.reloadRowWithText(10, text: "Chemistry")
            }))
            action.addAction(UIAlertAction(title: "Mathematics", style: .Default, handler: {_ in
                self.reloadRowWithText(10, text: "Mathematics")
            }))
            action.addAction(UIAlertAction(title: "Math + Physics", style: .Default, handler: {_ in
                self.reloadRowWithText(10, text: "Math + Physics")
            }))
            action.addAction(UIAlertAction(title: "Math + Chemistry", style: .Default, handler: {_ in
                self.reloadRowWithText(10, text: "Math + Chemistry")
            }))
            action.addAction(UIAlertAction(title: "Physics + Chemistry", style: .Default, handler: {_ in
                self.reloadRowWithText(10, text: "Physics + Chemistry")
            }))
            action.addAction(UIAlertAction(title: "Physics + Chemistry + Math", style: .Default, handler: {_ in
                self.reloadRowWithText(10, text: "Physics + Chemistry + Math")
            }))
            action.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {_ in
                
            }))
            self.presentViewController(action, animated: true, completion: nil)
        }

    }
    
    func reloadRowWithText(row:Int,text:String){
        self.arrTeacher.removeAtIndex(row)
        self.arrTeacher.insert(text, atIndex: row)
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        self.tableView!.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return countryList.count
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return countryList[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        arrStudent.removeAtIndex(4)
        arrStudent.insert( countryList[row], atIndex: 4)
        arrTeacher.removeAtIndex(4)
        arrTeacher.insert( countryList[row], atIndex: 4)
        let indexPath = NSIndexPath(forRow: 4, inSection: 0)
        tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
               if textField.tag == 2{
            if textField.text?.characters.count > 0{
                if self.validateEmail(textField.text!){
                    return true
                }
                else{
                    return false
                }
            }
        }
        if textField.tag == 3{
            if textField.text?.characters.count > 0{
                if self.validatePhone(textField.text!){
                    return true
                }
                else{
                    return false
                }
            }
        }
            arrStudent.removeAtIndex(textField.tag)
            arrStudent.insert(textField.text!, atIndex: textField.tag)
        arrTeacher.removeAtIndex(textField.tag)
        arrTeacher.insert(textField.text!, atIndex: textField.tag)
            return true
        
    }
    func textFieldDidEndEditing(textField: UITextField){
        arrStudent.removeAtIndex(textField.tag)
        arrStudent.insert(textField.text!, atIndex: textField.tag)
        arrTeacher.removeAtIndex(textField.tag)
        arrTeacher.insert(textField.text!, atIndex: textField.tag)
    

    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool{
        arrStudent.removeAtIndex(textField.tag)
        arrStudent.insert(textField.text!, atIndex: textField.tag)
        arrTeacher.removeAtIndex(textField.tag)
        arrTeacher.insert(textField.text!, atIndex: textField.tag)
        return true
    }
    func validatePhone(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluateWithObject(value)
        return result
    }
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluateWithObject(enteredEmail)
        
    }
    
    func signup() -> Void {
        print(arrTeacher)
        print(arrStudent)
    }
}
