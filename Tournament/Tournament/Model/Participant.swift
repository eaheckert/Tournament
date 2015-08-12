//
//  Participant.swift
//  Tournament
//
//  Created by Eugene Heckert on 8/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

import Foundation

class Participant
{
    var participantId: String = ""
    var name: String = ""
    var userName: String = ""
    var displayName: String = ""
    
    class func parseParticipantFromJson(jsonAr:Array<AnyObject>) -> Array<Participant>
    {
        var partList:Array<Participant> = []
        
        for object: AnyObject in jsonAr
        {
            if let json = object as? Dictionary<String,AnyObject>
            {
                var participant: Participant = Participant()
                
                participant.loadParticipant(json)
                
                partList.append(participant)
            }
            
        }
        
        return partList
    }
    
    func loadParticipant(participant:Dictionary<String,AnyObject>)
    {
        participantId = participant["participantID"]! as! String
        name = participant["name"]! as! String
        userName = participant["userName"]! as! String
        displayName = participant["displayName"]! as! String
        
    }
}
