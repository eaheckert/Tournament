//
//  TTournamentListVC.swift
//  Tournament
//
//  Created by Eugene Heckert on 8/5/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

import Foundation
import Parse

class TTournamentListVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //MARK: Varibles
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: View Controller Method
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.getTournamentList()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Custom Functions
    
    func getTournamentList()
    {
        //Check to see if the user has a username
        //If not load loginVC
        if let userNameString = User.activeUser.username
        {
            var query = PFQuery(className: "Tournament")
            
            query.whereKey("createdBy", equalTo:User.activeUser.username!)
            
            query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error:NSError?) -> Void in
                if error == nil
                {
                    println("objects: ", objects)
                }
                else
                {
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }
        }
        else
        {
            println("No userName")
            
            //If there is no user name we know there is no user.
            //So we present the login view controller.
            //It is presented as a Model since the user can't use the app without
            //being a regisited user.
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            
            let loginVC = storyboard.instantiateViewControllerWithIdentifier("TLoginVC") as! TLoginVC
            
            self.navigationController?.presentViewController(loginVC, animated: true, completion: nil)
        }
        
    }
    
    
    //MARK: UITableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("TTournamentCell") as! TTournamentCell

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
}
