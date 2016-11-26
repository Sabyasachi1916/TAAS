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
}
