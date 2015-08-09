//
//  TTournamentCell.swift
//  Tournament
//
//  Created by Eugene Heckert on 8/5/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

import Foundation

class TTournamentCell: UITableViewCell
{
    
    //MARK: IB Variables
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var gameNameLabel: UILabel!
    
    
    //MARK: class Variables
    
    private var tournament:Tournament!
    
    
    //MARK: class initializer
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    
    //MARK: Custom class methods
    
    func loadTournament(tour: Tournament)
    {
        tournament = tour
        
        titleLabel.text = tournament.name
        typeLabel.text = tournament.tournamentType
        gameNameLabel.text = tournament.gameName
    }
    
}