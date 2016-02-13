
//
//  Created by Kyle Willcox on 2/17/15.
//  Copyright (c) 2015 TimeLapse. All rights reserved.
//

import Foundation
import UIKit


class HowlViewController : UIViewController{
    
    //The text field for title
    @IBOutlet weak var howlTitleTextField: UITextField!
    
    //Text field for howl
    @IBOutlet weak var howlTextField: UITextField!
    var howlLAT:Double!
    var howlLON:Double!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //howlTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200.00, height: 40.00));

        //self.view.addSubview(howlTextField)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Resign keyboard for textfields
    @IBAction func viewTapped(sender :AnyObject){
        
    howlTextField.resignFirstResponder()
    howlTitleTextField.resignFirstResponder()
        
    }
    
 
    //Submit howl button action
    @IBAction func howlWasPressed(sender: AnyObject) {
        
        //if both fields have been filled in proceed
        if(howlTextField.hasText() && howlTitleTextField.hasText())
        {
            var howlTitle = howlTitleTextField.text as NSString
            var howl = howlTextField.text as NSString
            
            //Formating double
            var latSTR = NSString(format: "%.4f", howlLAT)
            var lonSTR = NSString(format: "%.4f", howlLON)
            
            //Create NSURL to web endpoint
            var url: NSURL = NSURL(string: "http://www.uncwskimclub.com/local.php")!
            var request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
            
            //The body data to be posted to php page
            var bodyData = "title=\(howlTitle)&howl=\(howl)&lat=\(latSTR)&lon=\(lonSTR)"
            
            //println("The body data is\(bodyData)")
            
            //Create and send a post message
            request.HTTPMethod = "POST"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
                {
                    (response, data, error) in
                    println(response)
                    
            }
            
            
        }
    }
}
