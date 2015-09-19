//
//  TLoginVC.swift
//  Tournament
//
//  Created by Eugene Heckert on 8/6/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

import Foundation
import Parse

class TLoginVC: UIViewController
{
    
    
    //MARK: Variables
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    //MARK: View Controller Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        
        //We do this check so that if we come back from registering user with a new active user they don't need to sign-in.
        //This is because the registering process signs the user in at the same time.
        let currentUser = User.currentUser()
        
        if currentUser != nil
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    //MARK: IBAction Methods
    
    @IBAction func onLoginAction(sender: AnyObject)
    {
        //First check to make sure that the user has entered information the meets the requirements
        if self.validateLoginInformation()
        {
            [PFUser .logInWithUsernameInBackground(self.usernameTextField.text!, password: self.passwordTextField.text!, block: { (user: PFUser?, error: NSError?) -> Void in
                
                if user != nil
                {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else
                {
                    let alert = UIAlertController(title: "Error", message: error?.description, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            })];
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "The information you entered did not meet the minimum requirement for a username and password. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    //MARK: Custom Methods
    
    func validateLoginInformation() -> Bool
    {
        if usernameTextField.text?.characters.count < 0
        {
            return false
        }
        if passwordTextField.text?.characters.count < 6
        {
            return false
        }
        
        return true
    }
}
