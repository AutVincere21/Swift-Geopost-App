//
//  DataManager.swift
//  SkimClub
//
//  Created by Kyle Willcox on 1/29/15.
//  Copyright (c) 2015 TimeLapse. All rights reserved.
//

import Foundation

let skimsiteurl = "http://www.uncwskimclub.com/local.php"

class DataManager {
    
    class func getLocationDataWithSuccess(success: ((localData: NSData!) -> Void)) {
        
        loadDataFromURL(NSURL(string: skimsiteurl)!, completion:{(data, error) -> Void in
            
            if let urlData = data {
                
                success(localData: urlData)
            }
        })
    }
    
    
    
    class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        var session = NSURLSession.sharedSession()
        
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                //if httpResponse is not a sucessful status code report error
                if httpResponse.statusCode != 200 {
                    var statusError = NSError(domain:"com.uncwskimclub", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        loadDataTask.resume()
    }
}