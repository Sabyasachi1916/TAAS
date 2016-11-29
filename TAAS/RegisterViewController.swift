//
//  RegisterViewController.swift
//  TAAS
//
//  Created by SABYASACHI POLLEY on 23/11/16.
//  Copyright © 2016 SR. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class RegisterViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,NSURLSessionDelegate {
var arrCellNames = ["First Name","Last Name","Email","Phone Number","Country","Password","Confirm Password","Student","Grade","Signup"]
    var countryID: [String] = []
    var countryList: [String] = []//["Afghanistan","Albania","Algeria","Andorra","Angola","Antigua and Barbuda","Argentina","Armenia","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bhutan","Bolivia","Bosnia and Herzegovina","Botswana","Brazil","Brunei","Bulgaria","Burkina Faso","Burundi","Cabo Verde","Cambodia","Cameroon","Canada","Central African Republic (CAR)","Chad","Chile","China","Colombia","Comoros","Democratic Republic of the Congo","Republic of the Congo","Costa Rica","Cote d'Ivoire","Croatia","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia","Fiji","Finland","France","Gabon","Gambia","Georgia","Germany","Ghana","Greece","Grenada","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Honduras","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Kiribati","Kosovo","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Mauritania","Mauritius","Mexico","Micronesia","Moldova","Monaco","Mongolia","Montenegro","Morocco","Mozambique","Myanmar (Burma)","Namibia","Nauru","Nepal","Netherlands","New Zealand","Nicaragua","Niger","Nigeria","North Korea","Norway","Oman","Pakistan","Palau","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Qatar","Romania","Russia","Rwanda","Saint Kitts and Nevis","Saint Lucia","Saint Vincent and the Grenadines","Samoa","San Marino","Sao Tome and Principe","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","South Korea","South Sudan","Spain","Sri Lanka","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor-Leste","Togo","Tonga","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","Tuvalu","Uganda","Ukraine","United Arab Emirates (UAE)","United Kingdom (UK)","United States of America (USA)","Uruguay","Uzbekistan","Vanuatu","Vatican City (Holy See)","Venezuela","Vietnam","Yemen","Zambia","Zimbabwe"]
    var studentSelected = true
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
    var arrStudent = ["","","","","Select","","","",""]
    var arrTeacher = ["","","","","Select","","","","","Select","Select",""]
    var arrTextFields:[AnyObject]  = []
    @IBOutlet var tableView :UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.loadTableViewForStudent), name: "reloadForStudent", object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.loadTableViewForTeacher), name: "reloadForTeacher", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.signup), name: "signUp", object: nil)
        API.getCountryList({json in
           // print(json["data"])
            let arrCountryData = json["data"] as! NSArray
            for countryData in arrCountryData{
                let dict = NSDictionary(dictionary: countryData as! [NSObject : AnyObject])
                self.countryList.append(dict.valueForKey("name") as! String)
                self.countryID.append(dict.valueForKey("id") as! String)
            }
           // print(self.countryList)
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK: - RELOAD tableview for  student
    func loadTableViewForStudent() -> Void {
        arrCellNames = ["First Name","Last Name","Email","Phone Number","Country","Password","Confirm Password","Student","Grade","Signup"]
        studentSelected = true
    tableView?.reloadData()
    }
    
    
    //MARK: - RELOAD tableview for Teacher
    func loadTableViewForTeacher() -> Void {
        arrCellNames = ["First Name","Last Name","Email","Phone Number","Country","Password","Confirm Password","Student","Profession","Degree","Expertise","Signup"]
        studentSelected = false
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
            arrTextFields.append(cell.textField!)
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
            self.view.viewWithTag(200)?.frame = CGRectMake(0,self.view.frame.height,self.view.frame.width,250)
            }, completion: {(completion:Bool) in
                self.view.viewWithTag(200)?.removeFromSuperview()
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
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if textField.tag == 2{
            textField.keyboardType = UIKeyboardType.EmailAddress
        }
        if textField.tag == 3{
            textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        }
        if studentSelected == true{
            if textField.tag == 8{
                textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
            }
        }
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
        textField.resignFirstResponder()
        
            return true
        
    }
    func textFieldDidEndEditing(textField: UITextField){
        arrStudent.removeAtIndex(textField.tag)
        arrStudent.insert(textField.text!, atIndex: textField.tag)
        arrTeacher.removeAtIndex(textField.tag)
        arrTeacher.insert(textField.text!, atIndex: textField.tag)
    

    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool{
        if textField.tag == 6{
            if studentSelected == true{
                if  arrStudent[5] != textField.text{
                    API.showAlert(self, title: "Alert!", msg: "Password doe snot match!")
                    return false
                }
            }
            if studentSelected == false{
                if  arrTeacher[5] != textField.text{
                    API.showAlert(self, title: "Alert!", msg: "Password does not match!")
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
    func validatePhone(value: String) -> Bool {
        if value.characters.count != 10 {
            API.showAlert(self, title: "Alert!", msg: "Phone number must not be with 10 digits")
        }
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
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.stringByReplacingCharactersInRange(range, withString: string)
        if textField.tag == 8{
            arrStudent.removeAtIndex(textField.tag)
            arrStudent.insert(resultString, atIndex: textField.tag)
            arrTeacher.removeAtIndex(textField.tag)
            arrTeacher.insert(resultString, atIndex: textField.tag)
        }
        return true
    }
    func signup() -> Void {
        
        if studentSelected == true{
         print(arrStudent)
            if arrStudent[0] == ""{
                API.showAlert(self, title: "Alert!", msg: "Please Enter your first name.")
                return
            }
            if arrStudent[1] == ""{
                API.showAlert(self, title: "Alert!", msg: "Please Enter your last name.")
                return
            }
            if arrStudent[2] == ""{
                API.showAlert(self, title: "Alert!", msg: "Please Enter your email.")
                return
            }
            if arrStudent[3] == ""{
                API.showAlert(self, title: "Alert!", msg: "Please Enter your phone number.")
                return
            }
            if arrStudent[4] == ""{
                API.showAlert(self, title: "Alert!", msg: "Please select your country.")
                return
            }
            let params = ["user_type": "S", "email":arrStudent[2], "password":arrStudent[5], "firstname":arrStudent[0], "lastname":arrStudent[1],"country":countryID[countryList.indexOf(arrStudent[4])!] ,"grade":arrStudent[8],"phone":arrStudent[3]]
             print(params)
            self.AlamofireRegisterRequest(params, completion: {json in
                print(json)
let tempJson = JSON(json)
                if tempJson["status"].stringValue == "SUCCESS"{
                    let alert=UIAlertController(title: "Registration", message: "Registration successfull. Now TAAS will verify your provided info as soon as possible. Please wait until verification.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: {_ in
                        self.navigationController?.popViewControllerAnimated(true)
                    }));
                    self.presentViewController(alert, animated: true, completion: nil);
                    
                }else{
                    let msg = tempJson["message"].stringValue
                    let alert=UIAlertController(title: "Registration", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: {_ in
                        self.navigationController?.popViewControllerAnimated(true)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil);
                }
            })
//            self.register(params, completion: {json in
//                print(json)
//                dispatch_async(dispatch_get_main_queue()) {
//                    if String(json["status"]) == "SUCCESS"{
//                       
//                    }else{
//                        let msg = json["message"] as! String
//                        API.showAlert(self, title: "Registration", msg: msg)
//                    }
//                }
//            })
            
            
        }
        else{
            if arrTeacher[0] == ""{
                API.showAlert(self, title: "Alert!", msg: "Please Enter your first name.")
                return
            }
            if arrTeacher[1] == ""{
                API.showAlert(self, title: "Alert!", msg: "Please Enter your last name.")
                return
            }
            if arrTeacher[2] == ""{
                API.showAlert(self, title: "Alert!", msg: "Please Enter your email.")
                return
            }
            if arrTeacher[3] == ""{
                API.showAlert(self, title: "Alert!", msg: "Please Enter your phone number.")
                return
            }
            if arrTeacher[4] == ""{
                API.showAlert(self, title: "Alert!", msg: "Please select your country.")
                return
            }
            print(arrTeacher)
            let params = ["user_type": "T", "email":arrTeacher[2], "password":arrTeacher[5], "firstname":arrTeacher[0], "lastname":arrTeacher[1],"country":countryID[countryList.indexOf(arrStudent[4])!] ,"phone":arrStudent[3],"degree":arrTeacher[9],"profession":arrTeacher[8],"expertise":arrTeacher[10]]
            print(params)
            self.AlamofireRegisterRequest(params, completion: {json in
                print(json)
                let tempJson = JSON(json)
                if tempJson["status"].stringValue == "SUCCESS"{
                    let alert=UIAlertController(title: "Registration", message: "Registration successfull. Now TAAS will verify your provided info as soon as possible. Please wait until verification.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: {_ in
                        self.navigationController?.popViewControllerAnimated(true)
                    }));
                    self.presentViewController(alert, animated: true, completion: nil);
                    
                }else{
                    let msg = tempJson["message"].stringValue
                    let alert=UIAlertController(title: "Registration", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: {_ in
                        self.navigationController?.popViewControllerAnimated(true)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil);
                }
            })

            
        }
       
    }
    
    @IBAction func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
func register(params: [String:String],completion:(json:AnyObject) -> Void)->Void{
        let url = NSURL(string:"https://urtaas.com/api/register")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
    
            //let jsonData = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            request.HTTPBody = String(params).dataUsingEncoding(NSUTF8StringEncoding) //try NSJSONSerialization.dataWithJSONObject(params as [String:String], options: NSJSONWritingOptions())
    request.addValue("text/html", forHTTPHeaderField: "Content-Type")
    request.addValue("gzip,deflate", forHTTPHeaderField: "Accept-Encoding")
    request.addValue("Keep-Alive", forHTTPHeaderField: "Connection")
    
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue:nil)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    print("response was not 200: \(response)")
                    return
                }
            }
            if (error != nil) {
                print("error submitting request: \(error)")
                return
            }
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                completion(json: json)
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            
            
            // handle the data of the successful response here
        }
        task.resume()
    }
   
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
    }
    
    
    
    func AlamofireRegisterRequest(para : [String : AnyObject],completion:(json:AnyObject) -> Void)->Void{
        Alamofire.request(.POST, "https://urtaas.com/api/register",parameters: para).responseJSON {response in
                // print(response.description)
                switch response.result {
                case .Failure( let error):
                    print(error)
                case .Success(let responseObject):
                    completion(json: responseObject)
                    
                }
                
        }
}
}
