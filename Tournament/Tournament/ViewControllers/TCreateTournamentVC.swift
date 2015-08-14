//
//  TCreateTournamentVC.swift
//  Tournament
//
//  Created by Eugene Heckert on 8/9/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

import Foundation
import Parse


class TCreateTournamentVC : UIViewController
{
    
    //MARK: IB Variables
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var tournamentNameTextField: UITextField!
    @IBOutlet weak var gameNameTextField: UITextField!
    @IBOutlet weak var participantListView: UIView!
    @IBOutlet weak var participantListViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var participantNameEntryTextField: UITextField!
    
    //MARK: private class variables
    
    private var participantList: NSMutableArray = NSMutableArray()
    private var participantNameList: NSMutableArray = NSMutableArray()
    private var matchList: NSMutableArray = NSMutableArray()
    
    private var tournamentName: String?
    private var currentTournament: Tournament?
    private var nextParticipantViewFrame: CGRect?
    private var participantId: Int = 0
    private var roundCounter: Int  = 0
    
    private var assignedMatchKey: String = "assign Match Key"
    
    //MARK: VC Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "CREATE TOURNAMENT"
        
        
        /*We want to find a basic tournament name that the user hasn't user has not used.
        A basic user name is something like Tournament 01, Tournament 02...etc*/
        var user: User = User.currentUser()! as User
        var tournamentNames = user.tournamentNames
        
        var needsTitle: Bool = false
        var tournamentNumber: Int = 0
        var possibleName: String?
        
        do
        {
        
            tournamentNumber++
            needsTitle = false
            possibleName = String(format: "Tournament %02i", tournamentNumber)
            
            if contains(tournamentNames, possibleName!)
            {
                needsTitle = true
            }
        
        }while needsTitle
        
        self.tournamentName = possibleName
        
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        var tempView: TParticipantView = TParticipantView()
        
        self.nextParticipantViewFrame = CGRect(x: 0, y: 1, width: self.participantListView.frame.size.width, height: tempView.frame.size.height)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Custom Methods
    
    func createTournament()
    {
        //make sure the keyboard is no long on the screen
        self.dismissKeyboard()
        
        //Make sure that there are atleast two participants
        if self.participantList.count < 2
        {
            var alert = UIAlertController(title: "Error", message: "You cannot create a tournament without atleast two participants. Please add more now.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        /*When creating a tournament you want to create it with a PFObject
        this is due to the fact that it will allow parse to lazily create
        the class if you have not already created it with parse.*/
        var tournament = PFObject(className: "Tournament")
        
        tournament["name"] = self.tournamentName
        
        if count(self.gameNameTextField.text) > 0
        {
            tournament["gameName"] = self.gameNameTextField.text
        }
        else
        {
            tournament["gameName"] = "Unspecified game"
        }
        
        tournament["createdBy"] = User.currentUser()?.username
        
        self.createMatches()
        
        if self.matchList.count < 1
        {
            var alert = UIAlertController(title: "Error", message: "Was unable to create any matches.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        tournament["tournamentParticipantsDictAr"] = self.participantList
        
        tournament["tournamentMatchesDictAr"] = self.matchList
        
        tournament["maxNumberRounds"] = self.roundCounter
        
        tournament["participantsCount"] = self.participantList.count
        
        tournament.saveInBackgroundWithBlock { (succeeded, error:NSError?) -> Void in
            
            if succeeded
            {
                User.currentUser()?.tournamentNames.append(self.tournamentName!)
                
                User.currentUser()?.saveEventually()
                
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            else
            {
                var alert = UIAlertController(title: "Error", message: error?.description, preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func createMatchWithId(matchId:String, playerOneId:String, playerTwoId:String, playerOnePreReqMatch:String, playerTwoPreReqMatch:String, playerOnePreReqMatchLoser:Bool, playerTwoPreReqMatchLoser:Bool) -> NSDictionary
    {
        return [
                "matchID":matchId,
                "round":self.roundCounter,
                "playerOneID":playerOneId,
                "playerTwoID":playerTwoId,
                "playerOnePreReqMatchID":playerOnePreReqMatch,
                "playerTwoPreReqMatchID":playerTwoPreReqMatch,
                "playerOnePreReqMatchLoser":playerOnePreReqMatchLoser,
                "playerTwoPreReqMatchLoser":playerTwoPreReqMatchLoser,
                "winnerID":"",
                "loserID":""
                ]
    }
    
    func getNextParticipant() -> NSMutableDictionary
    {
        for var i = 0; i < self.participantList.count; i++
        {
            var participant: NSMutableDictionary = NSMutableDictionary(dictionary: self.participantList[i] as! [NSObject : AnyObject])
            
            if (participant.valueForKey(self.assignedMatchKey)?.boolValue != true)
            {
                return participant
            }
        }
        
        return NSMutableDictionary()
    }
    
    func isPowerOfTwo(x:Int) -> Bool
    {
        var value: Float = Float(x)
        
        while (((value % 2) == 0) && value > 1)
        {
            value /= 2
        }
        
        return Int(value) == 1
    }
    
    func createMatches()
    {
        var participantCount: Int = self.participantList.count
        var preReqMatchCounter: Int = 0
        var matchID: Int = 0
        var numberToEliminateRoundOne: Int = 0
        var numberOfByes: Int = 0
        
        self.roundCounter = 0
        
        /*For the tournament to work correctly you need a number of participants
        that are a power of two. If the number of participants are not a power
        of two you will need to find the number of people who need to be eliminated
        in round one so that round two is a power of two.*/
        while !self.isPowerOfTwo(participantCount)
        {
            numberToEliminateRoundOne++
            participantCount--
        }
        
        /*If you need to Elimination people you can safly assume that for each person
        who you need to eliminate you will have a round one match. After which all
        remaining players will get a bye to round two.*/
        if Bool(numberToEliminateRoundOne)
        {
            numberOfByes = (participantCount - numberToEliminateRoundOne)
            
            self.roundCounter++
            
            for var i = 0,j = 0;j < numberToEliminateRoundOne;i += 2, j++
            {
                var playerOne = self.getNextParticipant()
                playerOne.setValue(true, forKey: self.assignedMatchKey)
                
                var playerTwo = self.getNextParticipant()
                playerTwo.setValue(true, forKey: self.assignedMatchKey)
                
                var playerOneId = String(stringInterpolationSegment: playerOne.valueForKey("participantID"))
                var playerTwoId = String(stringInterpolationSegment: playerTwo.valueForKey("participantID"))
                var playerOnePreReqMatch: String = ""
                var playerTwoPreReqMatch: String = ""
                
                var match = self.createMatchWithId(String(matchID), playerOneId: playerOneId, playerTwoId: playerTwoId, playerOnePreReqMatch: playerOnePreReqMatch, playerTwoPreReqMatch: playerTwoPreReqMatch, playerOnePreReqMatchLoser: false, playerTwoPreReqMatchLoser: false)
                
                self.matchList.addObject(match)
                
                matchID += 1
            }
        }
        
        do
        {
            self.roundCounter++
            
            for var i = 0; i < participantCount; i += 2
            {
                var playerOne: NSMutableDictionary
                var playerTwo: NSMutableDictionary
                var playerOnePreReqMatch = ""
                var playerTwoPreReqMatch = ""
                var playerOneId = ""
                var playerTwoId = ""
                
                /*If you did not need to eliminate anyone the first round this will
                make round one matches. Round one matches are different from other
                matches due to the fact they do not have prerequisite matches and
                participants will be assigned to a match.*/
                if self.roundCounter == 1
                {
                    playerOne = self.getNextParticipant()
                    playerOne.setValue(true, forKey: self.assignedMatchKey)
                    
                    playerTwo = self.getNextParticipant()
                    playerTwo.setValue(true, forKey: self.assignedMatchKey)
                    
                    playerOneId = String(stringInterpolationSegment: playerOne.valueForKey("participantID"))
                    playerTwoId = String(stringInterpolationSegment: playerTwo.valueForKey("participantID"))
                    
                    playerOnePreReqMatch = ""
                    playerTwoPreReqMatch = ""
                }
                else
                if self.roundCounter == 2 && Bool(numberOfByes)
                {
                    /*If the number of byes is less then the number of people to
                    eliminated in round one it means that two matchs will have
                    to complete against each other to see advances to round two.
                    If the number of byes is greater then the number of participants
                    to eliminate then the winner of a match will face off against one
                    of the bye paticipants. If there enough byes some of them will be
                    full matches and will act like normal.*/
                    if numberOfByes >= numberToEliminateRoundOne
                    {
                        if numberToEliminateRoundOne > preReqMatchCounter
                        {
                            playerOne = self.getNextParticipant()
                            playerOne.setValue(true, forKey: self.assignedMatchKey)
                            
                            playerOneId = String(stringInterpolationSegment: playerOne.valueForKey("participantID"))
                            
                            playerTwoPreReqMatch = String(preReqMatchCounter)
                            
                            preReqMatchCounter++
                        }
                        else
                        {
                            playerOne = self.getNextParticipant()
                            playerOne.setValue(true, forKey: self.assignedMatchKey)
                            
                            playerTwo = self.getNextParticipant()
                            playerTwo.setValue(true, forKey: self.assignedMatchKey)
                            
                            playerOneId = String(stringInterpolationSegment: playerOne.valueForKey("participantID"))
                            playerTwoId = String(stringInterpolationSegment: playerTwo.valueForKey("participantID"))
                            
                            playerOnePreReqMatch = ""
                            playerTwoPreReqMatch = ""
                        }
                    }
                    else
                    {
                        if numberOfByes > preReqMatchCounter
                        {
                            playerOne = self.getNextParticipant()
                            playerOne.setValue(true, forKey: self.assignedMatchKey)
                            
                            playerOneId = String(stringInterpolationSegment: playerOne.valueForKey("participantID"))
                            
                            playerTwoPreReqMatch = String(preReqMatchCounter)
                            
                            preReqMatchCounter++
                        }
                        else
                        {
                            playerOnePreReqMatch = String(preReqMatchCounter)
                            
                            preReqMatchCounter++
                            
                            playerTwoPreReqMatch = String(preReqMatchCounter)
                            
                            preReqMatchCounter++
                        }
                    }
        
                }
                else
                {
                    playerOnePreReqMatch = String(preReqMatchCounter)
                    
                    preReqMatchCounter++
                    
                    playerTwoPreReqMatch = String(preReqMatchCounter)
                    
                    preReqMatchCounter++
                }
        
                
                var match = self.createMatchWithId(String(matchID), playerOneId: playerOneId, playerTwoId: playerTwoId, playerOnePreReqMatch: playerOnePreReqMatch, playerTwoPreReqMatch: playerTwoPreReqMatch, playerOnePreReqMatchLoser: false, playerTwoPreReqMatchLoser: false)
                
                self.matchList.addObject(match)
                
                matchID += 1
            
            }
            
            participantCount /= 2
        
        }while participantCount > 1
    }
    
    func dismissKeyboard()
    {
        self.tournamentNameTextField.resignFirstResponder()
        self.gameNameTextField.resignFirstResponder()
        self.participantNameEntryTextField.resignFirstResponder()
    }
    
    //MARK: IB Methods
    
    @IBAction func onAddParticipantAction(sender: AnyObject)
    {
        //check to make sure their is a name in the participant textfield
        if count(self.participantNameEntryTextField.text) < 1
        {
            var alert = UIAlertController(title: "Error", message: "Please enter the name of a participant.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        //If there is a name make sure that the name hasn't been entered already
        if (self.participantNameList as NSArray).containsObject(self.participantNameEntryTextField.text)
        {
            var alert = UIAlertController(title: "Error", message: "A participant by that name has already been created.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        /*As long as ther is a name in the participantNameTextField we add it to the list of participants and display the name on a list view for the 
        user to be able to see who has already been added to the tournament.*/
        var participantName = self.participantNameEntryTextField.text
        
        self.participantNameEntryTextField.text = ""
        
        var participantDict = ["participantID":self.participantId, "name":participantName, "userName":participantName, self.assignedMatchKey:false, "displayName":participantName]
        
        self.participantList.addObject(participantDict)
        
        self.participantId += 1
        
        var participantView: TParticipantView = TParticipantView()
        
        participantView.frame = self.nextParticipantViewFrame!
        
        participantView.loadParticipantName(participantName)
        
        if self.participantListViewHeightConstraint.constant == 0
        {
            self.participantListViewHeightConstraint.constant = 1
        }
        
        var constaint: CGFloat = ((self.nextParticipantViewFrame!.size.height + self.nextParticipantViewFrame!.origin.y) + 1)
        
        self.participantListViewHeightConstraint.constant = constaint
        
        self.nextParticipantViewFrame!.origin.y = constaint
        
        self.participantListView.addSubview(participantView)
    }
    
    @IBAction func onSelectTournamentTypeAction(sender: AnyObject)
    {
    }
    
    @IBAction func onCreateTournamentAction(sender: AnyObject)
    {
        if count(self.tournamentNameTextField.text) < 1
        {
            var alert = UIAlertController(title: "Warning", message: String(format: "You are about to create a tournament with no name. Do you want to us %@ as your tournament name?", self.tournamentName!), preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) -> Void in
                
                self.createTournament()
                
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        var user: User = User.currentUser()! as User
        var tournamentNames = user.tournamentNames
        
        if contains(tournamentNames, self.tournamentNameTextField.text!)
        {
            var alert = UIAlertController(title: "Error", message: String(format: "You already have a tournament with the name %@. Please use a different name.", self.tournamentNameTextField.text!), preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        self.tournamentName = self.tournamentNameTextField.text
        
        self.createTournament()
    }
    
}

