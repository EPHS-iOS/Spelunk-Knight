//
//  Skeleton.swift
//  knight
//
//  Created by 64002170 on 3/9/22.
//

import Foundation
import SpriteKit

class Skeleton: SKSpriteNode{
    var prevX:CGFloat
    var sp=CGFloat(3)
    init(pos: CGPoint, siz: CGSize){
        prevX=pos.x
        super.init(texture: SKTexture(imageNamed: "s1"), color: UIColor.clear, size: siz)
        position=pos
        self.physicsBody=SKPhysicsBody(texture: SKTexture(imageNamed: "s1"), alphaThreshold: 0.5, size: siz)
        physicsBody?.affectedByGravity=true
        physicsBody?.allowsRotation=false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(){
        if (Int(prevX)==Int(position.x)){
            sp = -sp
            xScale = -xScale
        }
        position.x += sp
        prevX=position.x-sp
        print(Int(position.x))
        
    }
    
}
