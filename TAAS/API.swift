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
    var spinner : UIActivityIndicatorView?
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
    
    class  func showActivityIndicator(vc: UIViewController) -> UIView {
        var loadingView: UIView = UIView()
       
            var spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
             loadingView = UIView()
             loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
             loadingView.center =  vc.view.center
             loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
             loadingView.alpha = 0.7
             loadingView.clipsToBounds = true
             loadingView.layer.cornerRadius = 10
            
             spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
             spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
             spinner.center = CGPoint(x: loadingView.bounds.size.width / 2, y: loadingView.bounds.size.height / 2)
            
             loadingView.addSubview( spinner)
             vc.view.addSubview( loadingView)
             spinner.startAnimating()
            
            loadingView.tag = 200
            return loadingView
    }
    
  
}
