//
//  TMatchView.swift
//  Tournament
//
//  Created by Eugene Heckert on 8/12/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

import Foundation

class TMatchView: UIView
{
    
    //MARK: IB Variables
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var playerOneView: UIView!
    @IBOutlet weak var playerOneNameLabel: UILabel!
    
    @IBOutlet weak var playerTwoView: UIView!
    @IBOutlet weak var playerTwoLabel: UILabel!
    
    @IBOutlet weak var matchSelectBtn: UIButton!
    
    //MARK: Custom Variables
    
    var currentTournament: Tournament!
    var selectedMatch: Match!
    var playerOne: Participant!
    var playerTwo: Participant!
    
    //MARK: Required Methods
    
    init()
    {
        super.init(frame: CGRectZero)
        NSBundle.mainBundle().loadNibNamed("TMatchView", owner: self, options: nil)
        self.addSubview(self.mainView)
        self.frame = self.mainView.frame
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("TMatchView", owner: self, options: nil)
        self.addSubview(self.mainView)
        self.frame = self.mainView.frame
    }
    
    override var frame: CGRect
    {
        get
        {
            return super.frame
        }
        set(newFrame)
        {
            super.frame = newFrame
            
            
            if (mainView != nil)
            {
                var frame = newFrame
                frame.origin = CGPointZero
                mainView.frame = frame
            }
            
        }
    }
    
    
    //MARK: IB Methods
    
    @IBAction func onMatchAction(sender: AnyObject)
    {
        
    }
    
    
    //MARK: Custom Methods
    
    func loadMatch(match:Match, tournament:Tournament)
    {
        selectedMatch = match
        
        currentTournament = tournament
        
        if Bool(count(selectedMatch.playerOneID))
        {
            playerOne = currentTournament.getParticipantById(selectedMatch.playerOneID)
            
            playerOneNameLabel.text = playerOne.displayName
        }
        else
        {
            playerOne = nil
            
            playerOneNameLabel.text = ""
        }
        
        if Bool(count(selectedMatch.playerTwoID))
        {
            playerTwo = currentTournament.getParticipantById(selectedMatch.playerTwoID)
            
            playerTwoLabel.text = playerTwo.displayName
        }
        else
        {
            playerTwo = nil
            
            playerTwoLabel.text = ""
        }
        
        if((count(selectedMatch.winnerID) > 0) && (count(selectedMatch.winnerID)) > 0)
        {
            if selectedMatch.winnerID == playerOne.participantId
            {
                playerOneView.backgroundColor = UIColor(red: 1.0, green: 191.0/255.0, blue: 0.0, alpha: 1.0)
                
                playerOneNameLabel.textColor = UIColor(red: 26.0/255.0, green: 24.0/255.0, blue: 24.0/255.0, alpha: 1.0)
                
                playerTwoView.backgroundColor = UIColor(red: 79.0/255.0, green: 79.0/255.0, blue: 79.0/255.0, alpha: 1.0)
                
                playerTwoLabel.textColor = UIColor.whiteColor()
            }
            else
            {
                playerOneView.backgroundColor = UIColor(red: 79.0/255.0, green: 79.0/255.0, blue: 79.0/255.0, alpha: 1.0)
                
                playerOneNameLabel.textColor = UIColor.whiteColor()
                
                playerTwoView.backgroundColor = UIColor(red: 1.0, green: 191.0/255.0, blue: 0.0, alpha: 1.0)
                
                playerTwoLabel.textColor = UIColor(red: 26.0/255.0, green: 24.0/255.0, blue: 24.0/255.0, alpha: 1.0)
            }
        }
        
        if((playerOne != nil) && (playerTwo != nil))
        {
            matchSelectBtn.enabled = true
        }
        else
        {
            matchSelectBtn.enabled = false
        }
    }
    
    func matchUpdated()
    {
        
    }
    
}
