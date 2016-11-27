//
//  API.swift
//  TAAS
//
//  Created by SABYASACHI POLLEY on 17/11/16.
//  Copyright © 2016 SR. All rights reserved.
//

import UIKit
enum JSONError: String, ErrorType {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

class API: NSObject
{
    // LogIn
    class func login(txtEmail:String,txtPass:String,completion:(json:AnyObject) -> Void)->Void{
        let urlPath = "https://urtaas.com/api/login?email=\(txtEmail)&password=\(txtPass)"
        guard let endpoint = NSURL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        let request = NSMutableURLRequest(URL:endpoint)
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
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
        }.resume()
    }
    
    
    //Alert
    class func showAlert(controller:UIViewController,title:String,msg:String){
        let alert=UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
        controller.presentViewController(alert, animated: true, completion: nil);
    }
    
    class func register(params: [String:String],completion:(json:AnyObject) -> Void)->Void{
        let url = NSURL(string:"https://urtaas.com/api/register")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        do {
        request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params as AnyObject, options: NSJSONWritingOptions())
        }catch{
          print("error")
        }
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
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
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let register = storyboard.instantiateViewControllerWithIdentifier("register") as! RegisterViewController
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
    
    
    class func getCountryList(completion:(json:AnyObject) -> Void)->Void{
      
        let urlPath = "https://urtaas.com/api/countries"
        guard let endpoint = NSURL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        let request = NSMutableURLRequest(URL:endpoint)
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
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
            }.resume()
    }
}
