//
//  skeleton.swift
//  knight
//
//  Created by 64002170 on 2/23/22.
//

import Foundation
import SpriteKit

class skeleton: SKSpriteNode{
    var v=5

    init(){
        super.init(texture: SKTexture(imageNamed: "s1"), color: UIColor.clear, size: CGSize(width: 22, height: 33))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(){
        position.x+=CGFloat(v)
    }
    
}


