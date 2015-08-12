//
//  Match.swift
//  Tournament
//
//  Created by Eugene Heckert on 8/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

import Foundation

class Match
{
    
    var matchID: String = ""
    var matchState: String = ""
    var round: Int = 0
    var playerOneID: String = ""
    var playerTwoID: String = ""
    var playerOneScore: Int = 0
    var playerTwoScore: Int = 0
    var playerOnePreReqMatchID: String = ""
    var playerTwoPreReqMatchID: String = ""
    var playerOnePreReqMatchLoser: String = ""
    var playerTwoPreReqMatchLoser: String = ""
    var winnerID: String = ""
    var loserID: String = ""
    
    class func parseParticipantFromJson(jsonAr:Array<AnyObject>) -> Array<Match>
    {
        var matchList:Array<Match> = []
        
        for object: AnyObject in jsonAr
        {
            if let json = object as? Dictionary<String,AnyObject>
            {
                var match: Match = Match()
                
                match.loadMatch(json)
                
                matchList.append(match)
            }
            
        }
        
        return matchList
    }
    
    func loadMatch(match:Dictionary<String,AnyObject>)
    {
        matchID = match["matchID"]! as! String
        matchState = match["matchState"]! as! String
        round = match["round"]! as! Int
        playerOneID = match["playerOneID"]! as! String
        playerTwoID = match["playerTwoID"]! as! String
        playerOneScore = match["playerOneScore"]! as! Int
        playerTwoScore = match["playerTwoScore"]! as! Int
        playerOnePreReqMatchID = match["playerOnePreReqMatchID"]! as! String
        playerTwoPreReqMatchID = match["playerTwoPreReqMatchID"]! as! String
        playerOnePreReqMatchLoser = match["playerOnePreReqMatchLoser"]! as! String
        playerTwoPreReqMatchLoser = match["playerTwoPreReqMatchLoser"]! as! String
        winnerID = match["winnerID"]! as! String
        loserID = match["loserID"]! as! String
    }
}
