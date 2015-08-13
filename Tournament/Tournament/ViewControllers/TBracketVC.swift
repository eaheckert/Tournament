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
    
    var matchViews:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
    var selectedTournament: Tournament!
    
    
    //MARK: Required Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = selectedTournament.name
        
        //Since to create a Tournament we need atleast two participants
        //We can assume there will never be one player so players should always be plural
        playerCountLabel.text = String(format: "%i Players", selectedTournament.participantsCount)
        
        if count(selectedTournament.gameName) > 0
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
        
    }
    
    
    //MARK: Custom Methods
    
    func buildTournamentBrackets()
    {
        
    }
    
}
