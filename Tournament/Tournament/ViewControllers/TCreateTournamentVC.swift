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
        
        title = "CREATE TOURNAMENT"
        
        
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
        
        tournamentName = possibleName
        
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        var tempView: TParticipantView = TParticipantView()
        
        nextParticipantViewFrame = CGRect(x: 0, y: 1, width: participantListView.frame.size.width, height: tempView.frame.size.height)
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
        dismissKeyboard()
        
        //Make sure that there are atleast two participants
        if participantList.count < 2
        {
            var alert = UIAlertController(title: "Error", message: "You cannot create a tournament without atleast two participants. Please add more now.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        /*When creating a tournament you want to create it with a PFObject
        this is due to the fact that it will allow parse to lazily create
        the class if you have not already created it with parse.*/
        var tournament = PFObject(className: "Tournament")
        
        tournament["name"] = tournamentName
        
        if count(gameNameTextField.text) > 0
        {
            tournament["gameName"] = gameNameTextField.text
        }
        else
        {
            tournament["gameName"] = "Unspecified game"
        }
        
        tournament["createdBy"] = User.currentUser()?.username
        
        createMatches()
        
        if matchList.count < 1
        {
            var alert = UIAlertController(title: "Error", message: "Was unable to create any matches.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        tournament["tournamentParticipantsDictAr"] = participantList
        
        tournament["tournamentMatchesDictAr"] = matchList
        
        tournament["maxNumberRounds"] = roundCounter
        
        tournament["participantsCount"] = participantList.count
        
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
                "round":roundCounter,
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
        for var i = 0; i < participantList.count; i++
        {
            var participant: NSMutableDictionary = participantList[i] as! NSMutableDictionary
            
            print(i)
            println(participant)
            
            var isUsed = participant.valueForKey(assignedMatchKey) as! Bool
            
            if !isUsed
            {
                participant.setObject(true, forKey: assignedMatchKey)
                
                print("Used participant: ")
                println(participant)
                
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
        var participantCount: Int = participantList.count
        var preReqMatchCounter: Int = 0
        var matchID: Int = 0
        var numberToEliminateRoundOne: Int = 0
        var numberOfByes: Int = 0
        
        roundCounter = 0
        
        /*For the tournament to work correctly you need a number of participants
        that are a power of two. If the number of participants are not a power
        of two you will need to find the number of people who need to be eliminated
        in round one so that round two is a power of two.*/
        while !isPowerOfTwo(participantCount)
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
            
            roundCounter++
            
            for var i = 0,j = 0;j < numberToEliminateRoundOne;i += 2, j++
            {
                var playerOne = getNextParticipant()
                
                var playerTwo = getNextParticipant()
                
                var playerOneId = playerOne.valueForKey("participantID") as! String
                var playerTwoId = playerTwo.valueForKey("participantID") as! String
                
                var playerOnePreReqMatch: String = ""
                var playerTwoPreReqMatch: String = ""
                
                var match = createMatchWithId(String(matchID), playerOneId: playerOneId, playerTwoId: playerTwoId, playerOnePreReqMatch: playerOnePreReqMatch, playerTwoPreReqMatch: playerTwoPreReqMatch, playerOnePreReqMatchLoser: false, playerTwoPreReqMatchLoser: false)
                
                matchList.addObject(match)
                
                matchID += 1
            }
        }
        
        do
        {
            roundCounter++
            
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
                if roundCounter == 1
                {
                    playerOne = getNextParticipant()
                    
                    playerTwo = getNextParticipant()
                    
                    playerOneId = playerOne.valueForKey("participantID") as! String
                    playerTwoId = playerTwo.valueForKey("participantID") as! String
                    
                    playerOnePreReqMatch = ""
                    playerTwoPreReqMatch = ""
                }
                else
                if roundCounter == 2 && Bool(numberOfByes)
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
                            playerOne = getNextParticipant()
                            
                            playerOneId = playerOne.valueForKey("participantID")  as! String
                            
                            playerTwoPreReqMatch = String(preReqMatchCounter)
                            
                            preReqMatchCounter++
                        }
                        else
                        {
                            playerOne = getNextParticipant()
                            
                            playerTwo = getNextParticipant()
                            
                            playerOneId = playerOne.valueForKey("participantID") as! String
                            playerTwoId = playerTwo.valueForKey("participantID") as! String
                            
                            playerOnePreReqMatch = ""
                            playerTwoPreReqMatch = ""
                        }
                    }
                    else
                    {
                        if numberOfByes > preReqMatchCounter
                        {
                            playerOne = getNextParticipant()
                            
                            playerOneId = playerOne.valueForKey("participantID") as! String
                            
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
        
                
                var match = createMatchWithId(String(matchID), playerOneId: playerOneId, playerTwoId: playerTwoId, playerOnePreReqMatch: playerOnePreReqMatch, playerTwoPreReqMatch: playerTwoPreReqMatch, playerOnePreReqMatchLoser: false, playerTwoPreReqMatchLoser: false)
                
                matchList.addObject(match)
                
                matchID += 1
            
            }
            
            participantCount /= 2
        
        }while participantCount > 1
    }
    
    func dismissKeyboard()
    {
        tournamentNameTextField.resignFirstResponder()
        gameNameTextField.resignFirstResponder()
        participantNameEntryTextField.resignFirstResponder()
    }
    
    //MARK: IB Methods
    
    @IBAction func onAddParticipantAction(sender: AnyObject)
    {
        //check to make sure their is a name in the participant textfield
        if count(participantNameEntryTextField.text) < 1
        {
            var alert = UIAlertController(title: "Error", message: "Please enter the name of a participant.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        //If there is a name make sure that the name hasn't been entered already
        if (participantNameList as NSArray).containsObject(participantNameEntryTextField.text)
        {
            var alert = UIAlertController(title: "Error", message: "A participant by that name has already been created.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        /*As long as ther is a name in the participantNameTextField we add it to the list of participants and display the name on a list view for the 
        user to be able to see who has already been added to the tournament.*/
        var participantName = participantNameEntryTextField.text
        
        participantNameEntryTextField.text = ""
        
        var participantDict:NSMutableDictionary = NSMutableDictionary()
        
        participantDict.setObject(String(participantId), forKey: "participantID")
        participantDict.setObject(participantName, forKey: "name")
        participantDict.setObject(participantName, forKey: "userName")
        participantDict.setObject(false, forKey: assignedMatchKey)
        participantDict.setObject(participantName, forKey: "displayName")
        
        
        
//        = ["participantID":String(participantId), "name":participantName, "userName":participantName, assignedMatchKey:false, "displayName":participantName]
        
        participantList.addObject(participantDict)
        
        participantId += 1
        
        var participantView: TParticipantView = TParticipantView()
        
        participantView.frame = nextParticipantViewFrame!
        
        participantView.loadParticipantName(participantName)
        
        if participantListViewHeightConstraint.constant == 0
        {
            participantListViewHeightConstraint.constant = 1
        }
        
        var constaint: CGFloat = ((nextParticipantViewFrame!.size.height + nextParticipantViewFrame!.origin.y) + 1)
        
        participantListViewHeightConstraint.constant = constaint
        
        nextParticipantViewFrame!.origin.y = constaint
        
        participantListView.addSubview(participantView)
    }
    
    @IBAction func onSelectTournamentTypeAction(sender: AnyObject)
    {
    }
    
    @IBAction func onCreateTournamentAction(sender: AnyObject)
    {
        if count(tournamentNameTextField.text) < 1
        {
            var alert = UIAlertController(title: "Warning", message: String(format: "You are about to create a tournament with no name. Do you want to us %@ as your tournament name?", tournamentName!), preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) -> Void in
                
                self.createTournament()
                
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        var user: User = User.currentUser()! as User
        var tournamentNames = user.tournamentNames
        
        if contains(tournamentNames, tournamentNameTextField.text!)
        {
            var alert = UIAlertController(title: "Error", message: String(format: "You already have a tournament with the name %@. Please use a different name.", tournamentNameTextField.text!), preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        tournamentName = tournamentNameTextField.text
        
        createTournament()
    }
    
}

