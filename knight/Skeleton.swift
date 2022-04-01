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
    var health = 45
    var sizee:CGSize
    var walkSprites :[SKTexture] = [SKTexture]()
    var attackSprites :[SKTexture] = [SKTexture]()
    var attackTimer = 0
    var i = 0
    var attacking=false
    init(pos: CGPoint, siz: CGSize){
        sizee=siz
        walkSprites.append(SKTexture(imageNamed: "s1"))
        walkSprites.append(SKTexture(imageNamed: "s2"))
        walkSprites.append(SKTexture(imageNamed: "s3"))
        walkSprites.append(SKTexture(imageNamed: "s4"))
        walkSprites.append(SKTexture(imageNamed: "s5"))
        walkSprites.append(SKTexture(imageNamed: "s6"))
        walkSprites.append(SKTexture(imageNamed: "s7"))
        walkSprites.append(SKTexture(imageNamed: "s8"))
        walkSprites.append(SKTexture(imageNamed: "s9"))
        walkSprites.append(SKTexture(imageNamed: "s10"))
        walkSprites.append(SKTexture(imageNamed: "s11"))
        walkSprites.append(SKTexture(imageNamed: "s12"))
        walkSprites.append(SKTexture(imageNamed: "s13"))
        attackSprites.append(SKTexture(imageNamed: "sa1"))
        attackSprites.append(SKTexture(imageNamed: "sa2"))
        attackSprites.append(SKTexture(imageNamed: "sa3"))
        attackSprites.append(SKTexture(imageNamed: "sa4"))
        attackSprites.append(SKTexture(imageNamed: "sa5"))
        attackSprites.append(SKTexture(imageNamed: "sa6"))
        attackSprites.append(SKTexture(imageNamed: "sa7"))
        attackSprites.append(SKTexture(imageNamed: "sa8"))
        attackSprites.append(SKTexture(imageNamed: "sa9"))
        attackSprites.append(SKTexture(imageNamed: "sa10"))
        attackSprites.append(SKTexture(imageNamed: "sa11"))
        attackSprites.append(SKTexture(imageNamed: "sa12"))
        attackSprites.append(SKTexture(imageNamed: "sa13"))
        attackSprites.append(SKTexture(imageNamed: "sa14"))
        attackSprites.append(SKTexture(imageNamed: "sa15"))
        attackSprites.append(SKTexture(imageNamed: "sa16"))
        attackSprites.append(SKTexture(imageNamed: "sa17"))
        attackSprites.append(SKTexture(imageNamed: "sa18"))
        prevX=pos.x
        super.init(texture: walkSprites[1], color: UIColor.clear, size: siz)
        position=pos
        self.physicsBody=SKPhysicsBody(rectangleOf: siz)
//        self.physicsBody=SKPhysicsBody(texture: walkSprites[1], alphaThreshold: 0.5, size: siz)
        physicsBody?.affectedByGravity=true
        physicsBody?.allowsRotation=false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(){
        self.attackTimer += 1
        if (!attacking){
            self.yScale=1
//            print(xScale)
            if ((self.xScale != 1)&&(self.xScale != -1)){
//                print("hi")
                self.xScale=self.xScale*22/43
//                self.physicsBody=SKPhysicsBody(texture: walkSprites[1], alphaThreshold: 0.5, size: sizee)
                self.physicsBody=SKPhysicsBody(rectangleOf: sizee)
                self.physicsBody?.allowsRotation=false
            }
            self.i += 1
            if (Int(prevX)==Int(position.x)){
                sp = -sp
                xScale = -xScale
            }
            self.texture=walkSprites[Int(self.i/5)]
            if (self.i>=64){
                i=0
            }
            position.x += sp
            prevX=position.x-sp
            if (attackTimer>=100){
                attacking=true
            }
        } else {
            self.yScale=37/33
            if ((self.xScale==1)||(self.xScale == -1)){
                self.xScale=self.xScale*43/22
//                self.physicsBody=SKPhysicsBody(texture: walkSprites[1], alphaThreshold: 0.5, size: sizee)
                self.physicsBody=SKPhysicsBody(rectangleOf: sizee)
                self.physicsBody?.allowsRotation=false
                self.physicsBody?.contactTestBitMask=PhysicsCategory.player
            }
            self.texture=attackSprites[Int((attackTimer-100)/3)]
            if (Int((attackTimer-100)/3)>=17){
                attacking=false
                attackTimer=0
            }
        }
        self.physicsBody?.categoryBitMask=PhysicsCategory.skeleton
//        sk.physicsBody?.contactTestBitMask=PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
        //        print(Int(position.x))
        
    }
    
}
