//
//  FirstBoss.swift
//  knight
//
//  Created by 64011731 on 4/13/22.
//

import Foundation
import SpriteKit

class FirstBoss: SKSpriteNode{
    var prevX:CGFloat
    var sp=CGFloat(3)
    var isattack1 = false
    var isattack2 = false
    var health = 10
    var sizee:CGSize
    var walkSprites :[SKTexture] = [SKTexture]()
    var attackSprites :[SKTexture] = [SKTexture]()
    var attackTimer = 0
    var isleft = false
    var i = 0
    var left : SKNode?
    var right : SKNode?
    var attacking=false
    var atk=false
    init(pos: CGPoint, siz: CGSize, leftnode: SKNode, rightnode: SKNode){
        sizee=siz
        
        prevX=pos.x
        super.init(texture: SKTexture(imageNamed: "attack1_1"), color: UIColor.clear, size: siz)
        position=pos
        left = leftnode
        right = rightnode
        self.physicsBody=SKPhysicsBody(rectangleOf: siz)
        self.physicsBody?.isDynamic=true
        self.physicsBody?.pinned=false
        
        physicsBody?.affectedByGravity=true
        physicsBody?.allowsRotation=false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attack1(){
        isattack1 = true
//        print("attack1")
        
        if let actionR = self.action(forKey: "runningRightBoss") {
            
            actionR.speed = 0
            
        }
        
        if let actionL = self.action(forKey: "runningLeftBoss") {
            
            actionL.speed = 0
            
        }
        
        
        let texture1 = SKTexture(imageNamed: "attack1_1")
        let texture2 = SKTexture(imageNamed: "attack1_2")
        let texture3 = SKTexture(imageNamed: "attack1_3")
        let texture4 = SKTexture(imageNamed: "attack1_4")
        let texture5 = SKTexture(imageNamed: "attack1_5")
        let texture6 = SKTexture(imageNamed: "attack1_6")
        let actionBlock = SKAction.run({
            //print("change")
            self.isattack1 = false
            if let actionR = self.action(forKey: "runningRightBoss") {
                
                actionR.speed = 1
                
            }
            if let actionL = self.action(forKey: "runningLeftBoss") {
                
                actionL.speed = 1
                
            }
            
        })
        let animate = SKAction.animate(with: [texture1, texture2, texture3, texture4, texture5, texture6], timePerFrame: 0.1)
        let sequence = SKAction.sequence([animate,actionBlock])
        
        self.run(sequence, withKey:"attackingRightAction")
        if(self.isleft==true){
        self.xScale = -1
        }else{
            self.xScale = 1
        }
        
    }
    func attack1Left(){
        isattack1 = true
//        print("attack1")
        
        if let actionR = self.action(forKey: "runningRightBoss") {
            
            actionR.speed = 0
            
        }
        
        if let actionL = self.action(forKey: "runningLeftBoss") {
            
            actionL.speed = 0
            
        }
        
        
        let texture1 = SKTexture(imageNamed: "attack1_1left")
        let texture2 = SKTexture(imageNamed: "attack1_2left")
        let texture3 = SKTexture(imageNamed: "attack1_3left")
        let texture4 = SKTexture(imageNamed: "attack1_4left")
        let texture5 = SKTexture(imageNamed: "attack1_5left")
        let texture6 = SKTexture(imageNamed: "attack1_6left")
        let actionBlock = SKAction.run({
            //print("change")
            self.isattack1 = false
            if let actionR = self.action(forKey: "runningRightBoss") {
                
                actionR.speed = 1
                
            }
            if let actionL = self.action(forKey: "runningLeftBoss") {
                
                actionL.speed = 1
                
            }
            
        })
        let animate = SKAction.animate(with: [texture1, texture2, texture3, texture4, texture5, texture6], timePerFrame: 0.1)
        let sequence = SKAction.sequence([animate,actionBlock])
        
        self.run(sequence, withKey:"attackingLeftAction")
        
        
        
        
    }
    func attack2(){
        isattack2 = true
        if let actionR = self.action(forKey: "runningRightBoss") {
            
            actionR.speed = 0
            
        }
        
        if let actionL = self.action(forKey: "runningLeftBoss") {
            
            actionL.speed = 0
            
        }
        let texture1 = SKTexture(imageNamed: "attack2_1")
        let texture2 = SKTexture(imageNamed: "attack2_2")
        let texture3 = SKTexture(imageNamed: "attack2_3")
        let texture4 = SKTexture(imageNamed: "attack2_4")
        let texture5 = SKTexture(imageNamed: "attack2_5")
        let texture6 = SKTexture(imageNamed: "attack2_6")
        let actionBlock = SKAction.run({
            //print("change")
            self.isattack2 = false
            if let actionR = self.action(forKey: "runningRightBoss") {
                
                actionR.speed = 1
                
            }
            if let actionL = self.action(forKey: "runningLeftBoss") {
                
                actionL.speed = 1
                
            }
            
        })
        let animate = SKAction.animate(with: [texture1, texture2, texture3, texture4, texture5, texture6], timePerFrame: 0.1)
        let sequence = SKAction.sequence([animate,actionBlock])
        if(self.isleft==true){
        self.xScale = -1
        }else{
        self.xScale = 1
        }
        
    }
    func runRight(){
        let texture1 = SKTexture(imageNamed: "run_1")
        let texture2 = SKTexture(imageNamed: "run_2")
        let texture3 = SKTexture(imageNamed: "run_3")
        let texture4 = SKTexture(imageNamed: "run_4")
        let texture5 = SKTexture(imageNamed: "run_5")
        let texture6 = SKTexture(imageNamed: "run_6")
        
        let animate = SKAction.animate(with: [texture1, texture2, texture3, texture4, texture5, texture6], timePerFrame: 0.1)
        self.run(SKAction.repeatForever(animate), withKey:"runningRightBoss")
    }
//    func runLeft(){
//
//        let texture1 = SKTexture(imageNamed: "run_1left")
//        let texture2 = SKTexture(imageNamed: "run_2left")
//        let texture3 = SKTexture(imageNamed: "run_3left")
//        let texture4 = SKTexture(imageNamed: "run_4left")
//        let texture5 = SKTexture(imageNamed: "run_5left")
//        let texture6 = SKTexture(imageNamed: "run_6left")
//        let animate = SKAction.animate(with: [texture1, texture2, texture3, texture4, texture5, texture6], timePerFrame: 0.1)
//        self.run(SKAction.repeatForever(animate), withKey:"runningLeftBoss")
//    }
    
    func jump(){
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 2980))
    }
    func update(){
        if(self.frame.intersects(left!.frame)){
            
            runRight()
            self.xScale = 1
            position.x += 15
            isleft=false
            attack1()
        }
        if(self.frame.intersects(right!.frame)){
            
            runRight()
            self.xScale = -1
            position.x -= 15
            isleft = true
            attack1()
        }
        if(isleft==false){
            position.x += 15
        }else{
            position.x -= 15
        }
        
        
        self.physicsBody?.categoryBitMask=PhysicsCategory.skeleton
        //        sk.physicsBody?.contactTestBitMask=PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
    }
    
    
}
//extension SKTexture {
//    class func flipImage(name:String,flipHoriz:Bool,flipVert:Bool)->SKTexture {
//        if !flipHoriz && !flipVert {
//            return SKTexture.init(imageNamed: name)
//        }
//        let image = UIImage(named:name)
//
//        UIGraphicsBeginImageContext(image!.size)
//        let context = UIGraphicsGetCurrentContext()
//
//        if !flipHoriz && flipVert {
//            // Do nothing, X is flipped normally in a Core Graphics Context
//            // but in landscape is inverted so this is Y
//        } else
//        if flipHoriz && !flipVert{
//            // fix X axis but is inverted so fix Y axis
//            context!.translateBy(x: 0, y: image!.size.height)
//            context!.scaleBy(x: 1.0, y: -1.0)
//            // flip Y but is inverted so flip X here
//            context!.translateBy(x: image!.size.width, y: 0)
//            context!.scaleBy(x: -1.0, y: 1.0)
//        } else
//        if flipHoriz && flipVert {
//            // flip Y but is inverted so flip X here
//            context!.translateBy(x: image!.size.width, y: 0)
//            context!.scaleBy(x: -1.0, y: 1.0)
//        }
//
//        CGContextDrawImage(context, CGRectMake(0.0, 0.0, image!.size.width, image!.size.height), image!.cgImage)
//
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext();
//        return SKTexture(image: newImage!)
//    }
//}



