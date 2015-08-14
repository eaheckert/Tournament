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
    var round: Int = 0
    var playerOneID: String = ""
    var playerTwoID: String = ""
    var playerOnePreReqMatchID: String = ""
    var playerTwoPreReqMatchID: String = ""
    var playerOnePreReqMatchLoser: Bool = false
    var playerTwoPreReqMatchLoser: Bool = false
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
        round = match["round"]! as! Int
        playerOneID = match["playerOneID"]! as! String
        playerTwoID = match["playerTwoID"]! as! String
        playerOnePreReqMatchID = match["playerOnePreReqMatchID"]! as! String
        playerTwoPreReqMatchID = match["playerTwoPreReqMatchID"]! as! String
        playerOnePreReqMatchLoser = match["playerOnePreReqMatchLoser"]! as! Bool
        playerTwoPreReqMatchLoser = match["playerTwoPreReqMatchLoser"]! as! Bool
        winnerID = match["winnerID"]! as! String
        loserID = match["loserID"]! as! String
    }
}
