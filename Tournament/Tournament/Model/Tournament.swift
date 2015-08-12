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
    
    //MARK: Tournament enum
    
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
    @NSManaged var tournamentMatchesDictAr:Array<AnyObject>
    @NSManaged var tournamentParticipantsDictAr:Array<AnyObject>
    
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
    
    static func parseClassName() -> String
    {
        return "Tournament"
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
    
    func getTournamentState() -> tournamentState
    {
        return Tournament.getTournamentStateFromString(self.tournamentState)
    }
    
    func convertMatches()
    {
//        let matchAr = Match.parseMatchFromJson(self.tournamentMatchesDictAr)
        
        self.tournamentMatches = []
    }
    
    func convertParticipants()
    {
        print(tournamentParticipantsDictAr)
//        var partAr: Array<Participant> = Participant.parseParticipantFromJson(self.tournamentParticipantsDictAr)
        
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
