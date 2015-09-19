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
    
    //MARK: Parse Class Variables
    
    @NSManaged var createdBy:String
    @NSManaged var name:String
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
    
    //MARK: Methods
    
    func convertMatches()
    {
//        let matchAr = Match.parseMatchFromJson(self.tournamentMatchesDictAr)
        
        self.tournamentMatches = []
    }
    
    func convertParticipants()
    {
        print(tournamentParticipantsDictAr, terminator: "")
//        var partAr: Array<Participant> = Participant.parseParticipantFromJson(self.tournamentParticipantsDictAr)
        
        self.tournamentParticipants = []
    }
    
    func getParticipantById(partId:String!) -> Participant
    {
        for part: Participant in tournamentParticipants
        {
            if part.participantId == partId
            {
                return part
            }
        }
        
        return Participant()
    }
    
    func saveTournament()
    {
        for match: Match in tournamentMatches
        {
            for var i = 0; i < tournamentMatchesDictAr.count; i++
            {
                let matchDict = tournamentMatchesDictAr[i] as! NSMutableDictionary
                
                if match.matchID == String(stringInterpolationSegment: matchDict["matchID"]!)
                {
                    matchDict.setValue(match.playerOneID, forKey: "playerOneID")
                    matchDict.setValue(match.playerTwoID, forKey: "playerTwoID")
                    
                    matchDict.setValue(match.winnerID, forKey: "winnerID")
                    matchDict.setValue(match.loserID, forKey: "loserID")
                }
            }
        }
        
        self.save()
    }
    
}
