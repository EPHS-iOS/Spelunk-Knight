//
//  Bat.swift
//  knight
//
//  Created by 64002170 on 5/3/22.
//

import Foundation
import SpriteKit

class Bat: SKSpriteNode{
    var prevX:CGFloat
    var sp=CGFloat(6)
    var health = 1
    var sizee:CGSize
    var flySprites :[SKTexture] = [SKTexture]()
    var i = 0
    var baseY:CGFloat
    init(pos: CGPoint, siz: CGSize){
        sizee=siz
        flySprites.append(SKTexture(imageNamed: "b1"))
        flySprites.append(SKTexture(imageNamed: "b2"))
        flySprites.append(SKTexture(imageNamed: "b3"))
        flySprites.append(SKTexture(imageNamed: "b4"))
        flySprites.append(SKTexture(imageNamed: "b3"))
        flySprites.append(SKTexture(imageNamed: "b2"))
        prevX=pos.x
        baseY=pos.y
        super.init(texture: flySprites[1], color: UIColor.clear, size: siz)
        position=pos
        self.physicsBody=SKPhysicsBody(rectangleOf: siz)
//        self.physicsBody=SKPhysicsBody(texture: walkSprites[1], alphaThreshold: 0.5, size: siz)
        physicsBody?.affectedByGravity=false
        physicsBody?.allowsRotation=false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(){
        self.xScale=self.sp/abs(self.sp)
        self.position.y=baseY
            self.yScale=1
//            print(xScale)
//            if ((self.xScale != 1)&&(self.xScale != -1)){
////                print("hi")
//                self.xScale=self.xScale*22/43
////                self.physicsBody=SKPhysicsBody(texture: walkSprites[1], alphaThreshold: 0.5, size: sizee)
//                self.physicsBody=SKPhysicsBody(rectangleOf: sizee)
//                self.physicsBody?.allowsRotation=false
//            }
            self.i += 1
            if (Int(prevX)==Int(position.x)){
                sp = -sp
                xScale = -xScale
            }
            self.texture=flySprites[Int(self.i/7)]
            if (self.i>=27){
                i=0
            }
            position.x += sp
            prevX=position.x-sp
        self.physicsBody?.categoryBitMask=PhysicsCategory.bat
//        sk.physicsBody?.contactTestBitMask=PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
        //        print(Int(position.x))
//        print(health)
    }
    
}

