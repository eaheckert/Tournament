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
    
}
