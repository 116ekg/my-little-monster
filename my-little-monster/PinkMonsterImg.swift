//
//  MonsterImg.swift
//  my-little-monster
//
//  Created by Eddie Keller on 3/24/16.
//  Copyright © 2016 Eddie Keller. All rights reserved.
//

import Foundation
import UIKit

class PinkMonsterImg: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        pinkPlayIdleAnimation()
    }
    
    func pinkPlayIdleAnimation() {
        self.image = UIImage(named: "pink_idle1")
        self.animationImages = nil
        
        var pinkImgArray = [UIImage]()
        for x in 1 ... 5 {
            let img = UIImage(named: "pink_idle\(x)")
            pinkImgArray.append(img!)
        }
        
        self.animationImages = pinkImgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func pinkPlayDeathAnimation() {
        self.image = UIImage(named: "pink_dead3")
        self.animationImages = nil
        
        var pinkImgArray = [UIImage]()
        for x in 1 ... 4 {
            let img = UIImage(named: "pink_dead\(x)")
            pinkImgArray.append(img!)
        }
        
        self.animationImages = pinkImgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
}