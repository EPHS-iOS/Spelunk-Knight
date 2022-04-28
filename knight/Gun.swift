//
//  Gun.swift
//  Infection Tag
//
//  Created by 64000774 on 12/15/20.
//

import SpriteKit

class Gun: SKSpriteNode {
    
//    var id: String
    var character: SKSpriteNode
//    var scale: CGFloat
    init(char: SKSpriteNode/*, scale: CGFloat*/) {
//        self.id = ID
        // Make a texture from an image, a color, and size
        let texture = SKTexture(imageNamed: "Gun")
        
        let color = UIColor.clear
        let size = CGSize(width: 92*1.3, height: 41*1.3)
//        self.scale=scale
        self.character = char
            // Call the designated initializer
        super.init(texture: texture, color: color, size: size)
        zPosition=1000
    }
    
    func setPosition() {
        self.xScale=character.xScale
//        self.zRotation=character.zRotation+CGFloat(Float.pi/2)
        var x:CGFloat
        var y:CGFloat
        x =  CGFloat(/*25*self.scale*cos(self.character.zRotation+CGFloat(Float.pi/4)) +*/ self.character.position.x+(self.xScale*self.character.size.width/2))
        y =  CGFloat(/*25*self.scale*sin(self.character.zRotation+CGFloat(Float.pi/4)) +*/ self.character.position.y+(self.character.size.height/10))
        self.position = CGPoint(x:x, y:y)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
