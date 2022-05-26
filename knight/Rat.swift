//
//  Rat.swift
//  Spelunk Knight
//
//  Created by 64002170 on 5/26/22.
//

import Foundation
import SpriteKit

class Rat: SKSpriteNode{
    var prevX:CGFloat
    var sp=CGFloat(6)
    var playercontact = false
    var health = 1
    var sizee:CGSize
    var walkSprites :[SKTexture] = [SKTexture]()
    var i = 0
    var baseY:CGFloat
    init(pos: CGPoint, siz: CGSize){
        sizee=siz
        walkSprites.append(SKTexture(imageNamed: "rat1"))
        walkSprites.append(SKTexture(imageNamed: "rat2"))
        walkSprites.append(SKTexture(imageNamed: "rat3"))
        walkSprites.append(SKTexture(imageNamed: "rat4"))
        prevX=pos.x
        baseY=pos.y
        super.init(texture: walkSprites[1], color: UIColor.clear, size: siz)
        position=pos
        self.physicsBody=SKPhysicsBody(rectangleOf: siz)
//        self.physicsBody=SKPhysicsBody(texture: walkSprites[1], alphaThreshold: 0.5, size: siz)
        physicsBody?.affectedByGravity=true
        physicsBody?.allowsRotation=false
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(){
      
        self.xScale=self.sp/abs(self.sp)
//        self.position.y=baseY
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
            if (Int(prevX)==Int(position.x)&&playercontact==false){
                
                sp = -sp
                xScale = -xScale
                position.x += sp
                prevX=position.x-sp
            }
            self.texture=walkSprites[Int(self.i/7)]
            if (self.i>=27){
                i=0
            }
        
            position.x += sp
            prevX=position.x-sp
        
      
        self.physicsBody?.categoryBitMask=PhysicsCategory.skeleton
//        sk.physicsBody?.contactTestBitMask=PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
        //        print(Int(position.x))
//        print(health)
    }
    


}
