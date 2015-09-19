//
//  TBracketVC.swift
//  Tournament
//
//  Created by Eugene Heckert on 8/11/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

import Foundation

class TBracketVC: UIViewController
{
    
    //MARK: IB Variables
    
    @IBOutlet weak var tournamentInfoView: UIView!
    @IBOutlet weak var playerCountLabel: UILabel!
    @IBOutlet weak var gameLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    
    //MARK: Custom Variables
    
    var matchViews:NSMutableDictionary = NSMutableDictionary()
    var selectedTournament: Tournament!
    
    var kX_POS_DEFAULT_VALUE: CGFloat = 30.0
    var kY_POS_DEFAULT_VALUE: CGFloat = 30.0
    
    
    //MARK: Required Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = selectedTournament.name
        
        //Since to create a Tournament we need atleast two participants
        //We can assume there will never be one player so players should always be plural
        playerCountLabel.text = String(format: "%i Players", selectedTournament.participantsCount)
        
        if selectedTournament.gameName.characters.count > 0
        {
            self.gameLabel.text = selectedTournament.gameName
        }
        else
        {
            gameLabel.text = "Unspecified game"
        }
        
        contentViewHeightConstraint.constant = view.frame.size.height - tournamentInfoView.frame.size.height
        contentViewWidthConstraint.constant = view.frame.size.width
        
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 0.25
        
        self.buildTournamentBrackets()
        
    }
    
    
    //MARK: Custom Methods
    
    func buildTournamentBrackets()
    {
        var xPos: CGFloat = kX_POS_DEFAULT_VALUE
        var yPos: CGFloat = kY_POS_DEFAULT_VALUE
        var lastGoodMatch: Int = 0
        
        for var i: Int = 1; i <= self.selectedTournament.maxNumberRounds; i++
        {
            let headerView: TRoundHeaderView = TRoundHeaderView()
            
            headerView.frame = CGRect(origin: CGPoint(x: xPos, y: yPos), size: headerView.frame.size)
            
            if i == self.selectedTournament.maxNumberRounds
            {
                headerView.headerLabel.text = "Finals"
            }
            else if i == (self.selectedTournament.maxNumberRounds - 1)
            {
                headerView.headerLabel.text = "Semifinals"
            }
            else
            {
                headerView.headerLabel.text = String(format: "Round %i", i)
            }
            
            contentView.addSubview(headerView)
            
            yPos += (headerView.frame.size.height + kY_POS_DEFAULT_VALUE)
            
            for var j: Int = lastGoodMatch; j < selectedTournament.tournamentMatches.count; j++
            {
                let match = selectedTournament.tournamentMatches[j] as Match
                
                if match.round == i
                {
                    let matchView = TMatchView()
                    
                    matchView.frame = CGRect(origin: CGPoint(x: xPos, y: yPos), size: matchView.frame.size)
                    
                    if match.round != 1
                    {
                        var playerOnePreMatch: TMatchView?
                        var playerTwoPreMatch: TMatchView?
                        
                        if Bool(match.playerOnePreReqMatchID.characters.count)
                        {
                            playerOnePreMatch = matchViews[match.playerOnePreReqMatchID] as? TMatchView
                        }
                        
                        if Bool(match.playerTwoPreReqMatchID.characters.count)
                        {
                            playerTwoPreMatch = matchViews[match.playerTwoPreReqMatchID] as? TMatchView
                        }
                        
                        if((playerOnePreMatch != nil) && (playerTwoPreMatch != nil))
                        {
                            
                            let playerOneCenterY: CGFloat = playerOnePreMatch!.center.y
                            let playerTwoCenterY: CGFloat = playerTwoPreMatch!.center.y
                            
                            matchView.center = CGPoint(x: matchView.center.x, y: ((playerOneCenterY + playerTwoCenterY)/2))

                        }
                        else
                        if((playerOnePreMatch != nil) || (playerTwoPreMatch != nil))
                        {
                            var vaildMatch: TMatchView?
                            
                            if playerOnePreMatch != nil
                            {
                                vaildMatch = playerOnePreMatch
                            }
                            else
                            {
                                vaildMatch = playerTwoPreMatch
                            }
                            
                            matchView.center = CGPoint(x: matchView.center.x, y: vaildMatch!.center.y)
                        }
                    }
                    
                    matchView.loadMatch(match, tournament: selectedTournament)
                    
                    contentView.addSubview(matchView)
                    
                    matchViews.setObject(matchView, forKey: match.matchID)
                    
                    yPos += (matchView.frame.size.height * 1.5)
                    
                    if yPos > contentViewHeightConstraint.constant
                    {
                        contentViewHeightConstraint.constant = yPos
                    }
                }
                else
                {
                    let matchView: TMatchView = TMatchView()
                    
                    xPos += (matchView.frame.size.width * 1.5)
                    
                    if((xPos + (matchView.frame.size.width + kX_POS_DEFAULT_VALUE)) > contentViewWidthConstraint.constant)
                    {
                        contentViewWidthConstraint.constant = (xPos + (matchView.frame.size.width + kX_POS_DEFAULT_VALUE))
                    }
                    
                    lastGoodMatch = j
                    
                    yPos = kY_POS_DEFAULT_VALUE
                    
                    break;
                }
            }
        }
    }
    
}
