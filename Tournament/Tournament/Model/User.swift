//
//  User.swift
//  Tournament
//
//  Created by Eugene Heckert on 8/5/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

import Foundation
import Parse

class User: PFUser, PFSubclassing
{
    
    @NSManaged var tournamentNames:NSMutableArray
    
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
    
}
