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
    
    private var comingFromLogin: Bool = false
    
    private var pendingTournaments: NSMutableArray = NSMutableArray()
    private var underwayTournaments: NSMutableArray = NSMutableArray()
    private var awaitingTournaments: NSMutableArray = NSMutableArray()
    private var completedTournaments: NSMutableArray = NSMutableArray()
    
    private var pendingSection: Int = -1
    private var underwaySection: Int = -1
    private var awaitingSection: Int = -1
    private var completedSection: Int = -1
    
    private var selectedTournament: Tournament = Tournament()
    
    
    //MARK: View Controller Method
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.getTournamentList()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Check to see if LoginVC was displayed if so refreash data
        if self.comingFromLogin
        {
            self.comingFromLogin = false
            
            self.getTournamentList()
        }
        
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
        var currentUser = User.currentUser()
        
        if currentUser != nil
        {
            
            var query = PFQuery(className: "Tournament")
            
            var username = currentUser?.username
            
            query.whereKey("createdBy", equalTo:username!)
            
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
            
            //mark that the LoginVC is going to be displayed so that when we return the data gets refreshed.
            self.comingFromLogin = true
            
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        var numberOfSection: Int = 0;
        
        if self.pendingTournaments.count > 0
        {
            self.pendingSection = numberOfSection
            numberOfSection++
        }
        if self.underwayTournaments.count > 0
        {
            self.underwaySection = numberOfSection
            numberOfSection++
        }
        if self.awaitingTournaments.count > 0
        {
            self.awaitingSection = numberOfSection
            numberOfSection++
        }
        if self.completedTournaments.count > 0
        {
            self.completedSection = numberOfSection
            numberOfSection++
        }
        
        return numberOfSection;
        
    }
    
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
