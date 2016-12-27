//
//  RoundBtn.swift
//  social78
//
//  Created by Dennis Hedlund on 2016-12-27.
//  Copyright © 2016 Dennis Hedlund. All rights reserved.
//

import UIKit

class RoundBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        imageView?.contentMode = .scaleAspectFit // för bilden f

        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // om vi har denna rad i awakefromNib så kommer det inte fungera då knappen inte har ritats ut ännu?
        // frame size har räknats ut och vi kan göra en beräkning.
        layer.cornerRadius = self.frame.width / 2
    }
}
