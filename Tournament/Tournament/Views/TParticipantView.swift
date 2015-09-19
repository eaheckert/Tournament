//
//  TParticipantView.swift
//  Tournament
//
//  Created by Eugene Heckert on 8/9/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

import Foundation

class TParticipantView: UIView
{
    
    //MARK: IB Variables
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var participantNameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarImageViewWidthConstraint: NSLayoutConstraint!
    
    
    //MARK: Required Methods
    
    init()
    {
        super.init(frame: CGRectZero)
        NSBundle.mainBundle().loadNibNamed("TParticipantView", owner: self, options: nil)
        self.addSubview(self.mainView)
        self.frame = self.mainView.frame
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        NSBundle.mainBundle().loadNibNamed("TParticipantView", owner: self, options: nil)
        self.addSubview(self.mainView)
        self.frame = self.mainView.frame
    }
    
    override var frame: CGRect
    {
        didSet
        {
            if self.mainView != nil
            {
                self.mainView.frame = CGRect(origin: CGPointZero, size: frame.size)
            }
        }
    }
    
    
    //MARK: Custom Methods
    
    func loadParticipantName(name: String)
    {
        self.participantNameLabel.text = name
    }
    
    func loadParticipant(part: Participant)
    {
        
    }
}