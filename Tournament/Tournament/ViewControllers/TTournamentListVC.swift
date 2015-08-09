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
    //MARK: Variables
    
    @IBOutlet weak var tableView: UITableView!
    
    private var comingFromLogin: Bool = false
    private var firstTime: Bool = true
    
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
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Check to see if LoginVC was displayed if so refreash data
        if self.comingFromLogin || firstTime
        {
            self.comingFromLogin = false
            self.firstTime = false
            
            self.getTournamentList()
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Custom Methods
    
    func getTournamentList()
    {
        //Check to see if the user has a username
        //If not load loginVC
        var currentUser = User.currentUser()
        
        if currentUser != nil
        {
            self.pendingTournaments.removeAllObjects()
            self.underwayTournaments.removeAllObjects()
            self.awaitingTournaments.removeAllObjects()
            self.completedTournaments.removeAllObjects()
            
            var query = PFQuery(className: "Tournament")
            
            var username = currentUser?.username
            
            query.whereKey("createdBy", equalTo:username!)
            
            query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error:NSError?) -> Void in
                
                if error == nil
                {
                    println("objects: ", objects)
                    
                    for var i = 0; i < objects?.count; i++
                    {
                        if let tempTour = objects?[i] as? Tournament
                        {
                            var state = tempTour.getTournamentState()
                            
                            //Fill the different section array based off the tournament's section
                            if state == Tournament.tournamentState.TOURNAMENT_PENDING
                            {
                                self.pendingTournaments.addObject(tempTour)
                            }
                            else
                            if state == Tournament.tournamentState.TOURNAMENT_UNDERWAY
                            {
                                self.underwayTournaments.addObject(tempTour)
                            }
                            else
                            if state == Tournament.tournamentState.TOURNAMENT_AWAITING_REVIEW
                            {
                                self.awaitingTournaments.addObject(tempTour)
                            }
                            else
                            if state == Tournament.tournamentState.TOURNAMENT_COMPLETE
                            {
                                self.completedTournaments.addObject(tempTour)
                            }
                        }
                    }
                    
                    //before we reload the tableview we want to reset the section values so that they can be filled as needed while reloading the tableview.
                    //This is to prevent to sections ending up with same number if one section goes from having tournaments to not having any.
                    self.pendingSection = -1
                    self.underwaySection = -1
                    self.awaitingSection = -1
                    self.completedSection = -1
                    
                    self.tableView.reloadData()
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
            
            self.navigationController?.presentViewController(loginVC, animated: true, completion:  { () -> Void in
                
                //mark that the LoginVC is going to be displayed so that when we return the data gets refreshed.
                self.comingFromLogin = true
                
            })
        }
        
    }
    
    
    //MARK: UITableView Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        var numberOfSection: Int = 0;
        
        //Since we don't know which sections will have tournaments we load section numbers based off if that section has any tournaments.
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
        var rowCount: Int = 0
        
        if section == self.pendingSection
        {
            rowCount = self.pendingTournaments.count
        }
        else
        if section == self.underwaySection
        {
            rowCount = self.underwayTournaments.count
        }
        else
        if section == self.awaitingSection
        {
            rowCount = self.awaitingTournaments.count
        }
        else
        if section == self.completedSection
        {
            rowCount = self.completedTournaments.count
        }
        
        return rowCount
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 31.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        let header = tableView.dequeueReusableCellWithIdentifier("sectionHeaderCell") as! UIView
        let titleLabel = header.viewWithTag(1) as! UILabel
        
        
        if section == self.pendingSection
        {
            titleLabel.text = String(format: "Pending %i", self.pendingTournaments.count)
        }
        else
        if section == self.underwaySection
        {
            titleLabel.text = String(format: "Underway %i", self.underwayTournaments.count)
        }
        else
        if section == self.awaitingSection
        {
            titleLabel.text = String(format: "Awaiting %i", self.awaitingTournaments.count)
        }
        else
        if section == self.completedSection
        {
            titleLabel.text = String(format: "Completed %i", self.completedTournaments.count)
        }
        
        return header
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 84.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var tempTour: Tournament = Tournament()
        
        if indexPath.section == self.pendingSection
        {
            if indexPath.row > self.pendingTournaments.count
            {
                return UITableViewCell()
            }
            else
            {
                tempTour = self.pendingTournaments[indexPath.row] as! Tournament
            }
        }
        else
        if indexPath.section == self.underwaySection
        {
            if indexPath.row > self.underwayTournaments.count
            {
                return UITableViewCell()
            }
            else
            {
                tempTour = self.underwayTournaments[indexPath.row] as! Tournament
            }
        }
        else
        if indexPath.section == self.awaitingSection
        {
            if indexPath.row > self.awaitingTournaments.count
            {
                return UITableViewCell()
            }
            else
            {
                tempTour = self.awaitingTournaments[indexPath.row] as! Tournament
            }
        }
        else
        if indexPath.section == self.completedSection
        {
            if indexPath.row > self.completedTournaments.count
            {
                return UITableViewCell()
            }
            else
            {
                tempTour = self.completedTournaments[indexPath.row] as! Tournament
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TTournamentCell") as! TTournamentCell
        
        cell.loadTournament(tempTour)

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
}
