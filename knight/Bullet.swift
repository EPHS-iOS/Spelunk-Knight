//
//  Bullet.swift
//  Infection Tag
//
//  Created by 64000774 on 12/17/20.
//

//
//  Gun.swift
//  Infection Tag
//
//  Created by 64000774 on 12/15/20.
//

import SpriteKit

class Bullet: SKSpriteNode {
    
//    var shot: Bool = false
//    var pickedUp: Bool = false
    var time: Int?
    var ang: CGFloat?
    
    init(pos: CGPoint/*,scale: CGFloat*/ ) {
//        self.id = ID
        // Make a texture from an image, a color, and size
        let texture = SKTexture(imageNamed: "Gun")

        let color = UIColor.clear
        let size = CGSize(width: 50/**scale*/, height: 50/**scale*/)
            // Call the designated initializer
        super.init(texture: texture, color: color, size: size)
        self.position = pos
        self.time=0
    }
    
    func setPosition(xScale: CGFloat) {
//        if (self.shot) {
        self.xScale=xScale
            let x = self.position.x + xScale*10
            self.time!+=1
        self.position = CGPoint(x: x, y: self.position.y)
//        }
    }
    
//    func shoot(gun: Gun, angle: CGFloat) {
//        self.zRotation = angle+CGFloat(Float.pi/2)
//        self.shot = true
//        self.ang = angle
//        let x = gun.position.x
//        let y = gun.position.y
//        self.position = CGPoint(x: x, y: y)
//        self.time = 0
//
//    }
//    func pickUp() {
//        if pickedUp==false{
//            ammoCount+=1
//        }
//        pickedUp = true
//
//
//        self.removeFromParent()
//    }
    
    func doneShooting() -> Bool {
        if self.time! > 200 {
            self.removeFromParent()
            return true
        }
        return false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
