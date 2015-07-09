//
//  BrickMaker.swift
//  Brick Breaker
//
//  Created by Connor Pan on 7/9/15.
//  Copyright © 2015 Connor Pan. All rights reserved.
//

import UIKit

class BrickMaker: UIView {

    var brick = UIView()
    var color : UIColor!
    
    convenience init(brick: UIView, color: UIColor) {
        self.init()
        self.brick = brick
        self.color = color
    }
    
    
    
    

}
