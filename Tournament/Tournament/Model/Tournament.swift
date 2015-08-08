//
//  Tournament.swift
//  Tournament
//
//  Created by Eugene Heckert on 8/5/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

import Foundation
import Parse

//MARK: Tournament Class

class Tournament: PFObject, PFSubclassing
{
    
    //MARK: Tournament enums
    
    enum tournamentType
    {
        case DOUBLE_ELIMINATION
        case SINGLE_ELIMINATION
        case ROUND_ROBIN
        case SWISS
        case UNKNOWN_TOURNAMENT_TYPE
        
    }
    
    enum tournamentState
    {
        case TOURNAMENT_COMPLETE
        case TOURNAMENT_AWAITING_REVIEW
        case TOURNAMENT_UNDERWAY
        case TOURNAMENT_PENDING
        case UNKNOWN_TOURNAMENT_STATE
        
    }
    
    //MARK: Parse Class Variables
    
    @NSManaged var createdBy:String
    @NSManaged var name:String
    @NSManaged var tournamentType:String
    @NSManaged var tournamentState:String
    @NSManaged var quickAdvance:Bool
    @NSManaged var holdThirdPlaceMatch:Bool
    @NSManaged var gameName:String
    @NSManaged var participantsCount:Int
    @NSManaged var maxNumberRounds:Int
    @NSManaged var tournamentMatchesDictAr:Array<Dictionary<String,AnyObject>>
    @NSManaged var tournamentParticipantsDictAr:Array<Dictionary<String,AnyObject>>
    
    //MARK: Model Only Variables
    
    var tournamentMatches:Array<Match> = []
    var tournamentParticipants:Array<Participant> = []
    
    //MARK: Class Methods
    
    //If you override a Parse class it will need this method to be register the class with Parse
    override class func initialize()
    {
        struct Static
        {
            static var onceToken : dispatch_once_t = 0;
        }
        
        dispatch_once(&Static.onceToken)
        {
            self.registerSubclass()
        }
    }
    
    class func parseClassName() -> String
    {
        return "Tournament"
    }
    
    class func getTournamentTypeFromString(type:String!) -> tournamentType
    {
        if type.uppercaseString == "single elimination".uppercaseString
        {
            return tournamentType.SINGLE_ELIMINATION
        }
        else
        if type.uppercaseString == "double elimination".uppercaseString
        {
            return tournamentType.DOUBLE_ELIMINATION
        }
        else
        if type.uppercaseString == "swiss".uppercaseString
        {
            return tournamentType.SWISS
        }
        else
        if type.uppercaseString == "round robin".uppercaseString
        {
            return tournamentType.ROUND_ROBIN
        }
        else
        {
            return tournamentType.UNKNOWN_TOURNAMENT_TYPE
        }
    }
    
    class func getTournamentStateFromString(state:String!) -> tournamentState
    {
        if state.uppercaseString == "complete".uppercaseString
        {
            return tournamentState.TOURNAMENT_COMPLETE
        }
        else
        if state.uppercaseString == "awaiting_review".uppercaseString
        {
            return tournamentState.TOURNAMENT_AWAITING_REVIEW
        }
        else
        if state.uppercaseString == "underway".uppercaseString
        {
            return tournamentState.TOURNAMENT_UNDERWAY
        }
        else
        if state.uppercaseString == "pending".uppercaseString
        {
            return tournamentState.TOURNAMENT_PENDING
        }
        else
        {
            return tournamentState.UNKNOWN_TOURNAMENT_STATE
        }
    }
    
    //MARK: Methods
    
    func getTournamentType() -> tournamentType
    {
        return Tournament.getTournamentTypeFromString(self.tournamentType)
    }
    
    func getTournamentState() -> tournamentState
    {
        return Tournament.getTournamentStateFromString(self.tournamentState)
    }
    
    func convertMatches()
    {
        self.tournamentMatches = []
    }
    
    func convertParticipants()
    {
        self.tournamentParticipants = []
    }
    
    func getParticipantById(partId:String!) -> Participant
    {
        return Participant()
    }
    
    func saveTournament()
    {
        self.save()
    }
    
}
