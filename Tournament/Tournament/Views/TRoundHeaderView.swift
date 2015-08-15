//
//  TRoundHeaderView.swift
//  Tournament
//
//  Created by Eugene Heckert on 8/14/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

import Foundation

class TRoundHeaderView: UIView
{
    
    
    //MARK: IB Varaibles
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    
    //MARK: Required Methods
    
    init()
    {
        super.init(frame: CGRectZero)
        NSBundle.mainBundle().loadNibNamed("TRoundHeaderView", owner: self, options: nil)
        self.addSubview(self.mainView)
        self.frame = self.mainView.frame
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("TRoundHeaderView", owner: self, options: nil)
        self.addSubview(self.mainView)
        self.frame = self.mainView.frame
    }
    
    override var frame: CGRect
    {
        get
        {
            return super.frame
        }
        set(newFrame)
        {
            super.frame = newFrame
            
            
            if (mainView != nil)
            {
                var frame = newFrame
                frame.origin = CGPointZero
                mainView.frame = frame
            }
            
        }
    }
}
