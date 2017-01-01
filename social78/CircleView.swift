//
//  CircleView.swift
//  social78
//
//  Created by Dennis Hedlund on 2016-12-28.
//  Copyright © 2016 Dennis Hedlund. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}
