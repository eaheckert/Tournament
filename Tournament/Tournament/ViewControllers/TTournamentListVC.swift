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
    
    private var shouldRefreshOnReturn: Bool = false
    private var respondingToTouch: Bool = false
    private var firstTime: Bool = true
    
    private var tournaments: NSMutableArray = NSMutableArray()
    
    private var selectedTournament: Tournament = Tournament()
    
    
    //MARK: View Controller Method
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let plusImage = UIImage(named: "white_plus")?.imageWithRenderingMode(.AlwaysOriginal)
        let barButton = UIBarButtonItem(image: plusImage, style: UIBarButtonItemStyle.Plain, target: self, action: "onCreateTournamentAction")
        self.parentViewController?.navigationItem.rightBarButtonItem = barButton
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Check to see if LoginVC was displayed if so refreash data
        if self.shouldRefreshOnReturn || firstTime
        {
            self.shouldRefreshOnReturn = false
            self.firstTime = false
            
            self.getTournamentList()
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "To Single Elimination Bracket Segue"
        {
            print("Segue")
            
            if let vc = segue.destinationViewController as? TBracketVC
            {
                vc.selectedTournament = selectedTournament
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        respondingToTouch = false
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
        let currentUser = User.currentUser()
        
        if currentUser != nil
        {
            tournaments.removeAllObjects()
            
            let query = PFQuery(className: "Tournament")
            
            let username = currentUser?.username
            
            query.whereKey("createdBy", equalTo:username!)
            
            query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error:NSError?) -> Void in
                
                if error == nil
                {
                    print("objects: ", objects)
                    
                    for var i = 0; i < objects?.count; i++
                    {
                        if let tempTour = objects?[i] as? Tournament
                        {
                            self.tournaments.addObject(tempTour)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
                else
                {
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
        else
        {
            print("No userName")
            
            //If there is no user name we know there is no user.
            //So we present the login view controller.
            //It is presented as a Model since the user can't use the app without
            //being a regisited user.
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            
            let loginVC = storyboard.instantiateViewControllerWithIdentifier("TLoginVC") as! TLoginVC
            
            self.navigationController?.presentViewController(loginVC, animated: true, completion:  { () -> Void in
                
                //mark that the LoginVC is going to be displayed so that when we return the data gets refreshed.
                self.shouldRefreshOnReturn = true
                
            })
        }
        
    }
    
    func onCreateTournamentAction()
    {
        
        let createVC = self.storyboard!.instantiateViewControllerWithIdentifier("TCreateTournamentVC") as! TCreateTournamentVC
        
        //Since we might be adding a new tournament we need to refresh the list when the user returns to this view.
        self.shouldRefreshOnReturn = true
        
        self.navigationController?.pushViewController(createVC, animated: true)
    }
    
    
    //MARK: UITableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tournaments.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 31.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        let header = tableView.dequeueReusableCellWithIdentifier("sectionHeaderCell") as! UIView
        let titleLabel = header.viewWithTag(1) as! UILabel
        
        
        if tournaments.count == 1
        {
            titleLabel.text = String(format: "%i Tournament", tournaments.count)
        }
        else
        {
            titleLabel.text = String(format: "%i Tournaments", tournaments.count)
        }
        
        return header
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 63.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var tempTour: Tournament = Tournament()
        
        if indexPath.row >= tournaments.count
        {
            return UITableViewCell()
        }
        else
        {
            tempTour = tournaments[indexPath.row] as! Tournament
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TTournamentCell") as! TTournamentCell
        
        cell.loadTournament(tempTour)

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if respondingToTouch
        {
            return
        }
        
        respondingToTouch = true
        
        var tempTour: Tournament = Tournament()
        
        if indexPath.row >= tournaments.count
        {
            return
        }
        else
        {
            tempTour = tournaments[indexPath.row] as! Tournament
        }
        
        self.selectedTournament = tempTour
        
        if !Bool(self.selectedTournament.tournamentParticipants.count)
        {
            self.selectedTournament.tournamentParticipants = Participant.parseParticipantFromJson(self.selectedTournament.tournamentParticipantsDictAr)
        }
        
        if !Bool(self.selectedTournament.tournamentMatches.count)
        {
            self.selectedTournament.tournamentMatches = Match.parseParticipantFromJson(self.selectedTournament.tournamentMatchesDictAr)
        }
        
        self.performSegueWithIdentifier("To Single Elimination Bracket Segue", sender: self)
        
    }
    
}
