//
//  TRegisterUserVC.swift
//  Tournament
//
//  Created by Eugene Heckert on 8/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

import Foundation
import Parse

class  TRegisterUserVC: UIViewController
{
    
    
    //MARK: IB Variables
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    //MARK: View Controller Method
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: IBAction Methods
    
    @IBAction func onRegisterAccountAction(sender: AnyObject)
    {
        if self.validateUserInformation()
        {
            let user:User = User()
            
            user.username = self.usernameTextField.text
            user.password = self.passwordTextField.text
            user.email = self.emailTextField.text
            
            [user .signUpInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                if let error = error
                {
                    let errorString = error.userInfo["error"] as? String
                    
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else
                {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })]
        }
    }
    
    @IBAction func onCancelAction(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: Custom Methods
    
    func validateUserInformation() -> Bool
    {
        //First check to see if the user has entered sometype of username
        if self.usernameTextField.text!.characters.count <= 0
        {
            
            return false
        }
        
        //make sure the that there is something in the email field
        if self.usernameTextField.text!.characters.count <= 0
        {
            let alert = UIAlertController(title: "Error", message: "Please enter an email address.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return false
        }
        else
        {
            /*If the user has entered something into the email field lets see if has something@something.
              The reason we do this is because there could be one person with a strange email so we want
              a very permissive email check.*/
            
            let emailStr = self.emailTextField.text
            let delimiter = "@"
            let stringAr = emailStr!.componentsSeparatedByString(delimiter)
            
            if stringAr.count < 2
            {
                let alert = UIAlertController(title: "Error", message: "Please enter a valid email address.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                return false
            }
        }
        
        //make sure the that the password is long enough
        if self.passwordTextField.text?.characters.count < 6
        {
            let alert = UIAlertController(title: "Error", message: "Password is not long enough. Please enter a long password.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return false
        }
        
        //make sure that the password and the password confirm both match
        if self.passwordTextField.text != self.confirmPasswordTextField.text
        {
            let alert = UIAlertController(title: "Error", message: "Passwords don't match. Please make sure both passwords match.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
}