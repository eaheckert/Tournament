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
            
        }
        else
        {
            
        }
        
        if Bool(count(selectedMatch.playerTwoID))
        {
            
        }
        else
        {
            
        }
    }
    
    func matchUpdated()
    {
        
    }
    
}
