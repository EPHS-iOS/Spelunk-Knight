//
//  GameScene.swift
//  knight
//
//  Created by 64011731 on 2/14/22.
//
//testing push-rishi

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var menu = SKLabelNode(text: "menu")
    var health = SKLabelNode(text:"Health: 100")
    let cam = SKCameraNode()
    var player : SKSpriteNode?
    var tileMap : SKTileMapNode?
    var tileSize : CGSize?
    var turnedRight : Bool?
    var turnedLeft : Bool?
    var noTurn : Bool?
    var halfWidth : CGFloat?
    var canJump : Bool?
    var halfHeight : CGFloat?
    var nodesListGround = [SKShapeNode]()
    var skelV=CGFloat(80)
    let jump = SKSpriteNode(imageNamed: "jumparrowKnight")
    let attack = SKSpriteNode(imageNamed:"jStick")
    var skelTimer=0
    var attackSprites :[SKTexture] = [SKTexture]()
    let velocityMultiplier: CGFloat = 0.12
    var x : CGFloat?
    var y : CGFloat?
    struct PhysicsCategory {
      static let none      : UInt32 = 0
      static let all       : UInt32 = UInt32.max
//      static let bullet   : UInt32 = 0b1       // 1
        static let player : UInt32 = 0b10//2
     static let map : UInt32 = 0b11//3
//        static let key : UInt32 = 0b100//4
//        static let door : UInt32 = 0b101//5
//        static let mapEdge : UInt32 = 0b110//6
//        static let saw : UInt32 = 0b111//7
//        static let laser : UInt32 = 0b1000//8
    }
    lazy var analogJoystick: AnalogJoystick = {
        scene?.view?.showsPhysics = false
        let js = AnalogJoystick(diameter: scene!.size.width/9, colors: nil, images: (substrate: #imageLiteral(resourceName: "jSubstrate"), stick: #imageLiteral(resourceName: "jStick")))
        let ScreenSize = self.size
        js.position = CGPoint(x:-(scene!.size.width)/3, y: -(scene!.size.height)/3)
        js.zPosition = 3
        cam.addChild(js)
      return js
    }()
    override func didMove(to view: SKView) {
        turnedLeft = false
        turnedRight = false
        if(turnedLeft == false && turnedRight == false){
            noTurn = true
        }
        
        for i in 1...18{
           attackSprites.append(SKTexture(imageNamed: "sa"+String(i)))
        }
        scene!.enumerateChildNodes(withName: "//skeleton") {
            (node, stop) in
            node.isPaused=true
            node.isPaused=false
            node.physicsBody?.velocity.dx=self.skelV
        }
        view.isMultipleTouchEnabled=true
        setupJoystick()
        player = childNode(withName: "player") as?SKSpriteNode
        self.camera = cam
        cam.xScale=3
        cam.yScale=3
        self.addChild(cam)
        let constraint = SKConstraint.distance(SKRange(constantValue: 0), to: player!)
        camera!.constraints = [ constraint ]
        tileMap = (self.childNode(withName: "Tile Map Node") as? SKTileMapNode)!
       tileSize = tileMap?.tileSize
      halfWidth = CGFloat(tileMap!.numberOfColumns) / 2.0 * tileSize!.width
       halfHeight = CGFloat(tileMap!.numberOfRows) / 2.0 * tileSize!.height
     
        menu.position = CGPoint(x:camera!.position.x-(scene!.size.width)/3, y: camera!.position.y+(scene!.size.width)/5)
         menu.zPosition = 3
        menu.fontSize = scene!.size.width/19
         menu.fontColor = SKColor.white
         menu.alpha = 0.8
        
        health.position = CGPoint(x:camera!.position.x, y: camera!.position.y+(scene!.size.width)/5)
         health.zPosition = 3
        health.fontSize = scene!.size.width/19
         health.fontColor = SKColor.white
         health.alpha = 0.8
        cam.addChild(health)
        
         cam.addChild(menu)
        jump.position = CGPoint(x:camera!.position.x+(scene!.size.width)/4, y: camera!.position.y-(scene!.size.width)/5.5)
               jump.zPosition = 3
              jump.size=CGSize(width:scene!.size.width/7,height:scene!.size.width/6)
               jump.alpha = 0.8
               cam.addChild(jump)
        attack.position = CGPoint(x:camera!.position.x+(scene!.size.width)/2.8, y: camera!.position.y-(scene!.size.width)/6)
        attack.zPosition = 3
        attack.size = CGSize(width:scene!.size.width/15,height:scene!.size.width/15)
        attack.alpha = 1
        cam.addChild(attack)
       for col in 0..<tileMap!.numberOfColumns {
           for row in 0..<tileMap!.numberOfRows {
               let tileDefinition = tileMap!.tileDefinition(atColumn: col, row: row)
                let isCobblestone = tileDefinition?.userData?["Cobblestone"] as? Bool
                if (isCobblestone ?? false) {
                x = CGFloat(col) * tileSize!.width - halfWidth!
                 y = CGFloat(row) * tileSize!.height - halfHeight!
                   let rect = CGRect(x: 0, y: 0, width: tileSize!.width, height: tileSize!.height)
                    let tileNode = SKShapeNode(rect: rect)
                    tileNode.position = CGPoint(x: x!, y: y!)
                   tileNode.physicsBody = SKPhysicsBody.init(rectangleOf: tileSize!, center: CGPoint(x: tileSize!.width / 2.0, y: tileSize!.height / 2.0))
                    tileNode.physicsBody?.isDynamic = false
              
                   //tileNode.physicsBody?.usesPreciseCollisionDetection = true
                    tileNode.alpha=0
                   tileNode.physicsBody?.categoryBitMask = PhysicsCategory.map
                    tileNode.physicsBody?.friction = 0
                   tileNode.physicsBody?.collisionBitMask = PhysicsCategory.none
                   //tileNode.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
                   tileNode.physicsBody?.contactTestBitMask = PhysicsCategory.player
               
                   tileMap!.addChild(tileNode)
                   nodesListGround.append(tileNode)
                }
            }
        }
    }
    func setupJoystick() {
        //addChild(analogJoystick)
       
           analogJoystick.trackingHandler = { [unowned self] data in
               self.player?.position = CGPoint(x: (self.player?.position.x)! + (data.velocity.x * self.velocityMultiplier),
                                               y: (player?.position.y)!)
               if(data.velocity.x<0&&turnedLeft==false){
                turnedLeft = true
                   turnedRight = false
                   noTurn=false
                  
                  
                     //  print("changeleft")
                       player?.texture = SKTexture(imageNamed: "knightStandardLeft")
                    player?.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "knightStandardLeft"),
                                                          size:SKTexture(imageNamed: "knightStandardLeft").size())
                   player?.physicsBody?.allowsRotation=false
                   player?.physicsBody?.affectedByGravity=true
                 player?.physicsBody?.mass = 0.788289368152618
                   player?.physicsBody?.friction = 0.2
                   player?.physicsBody?.restitution = 0.2
                   player?.physicsBody?.linearDamping = 0.1
                   player?.physicsBody?.angularDamping = 0.1
                   
               }
               if(data.velocity.x>0&&turnedRight==false){
                   turnedRight = true
                   turnedLeft = false
                   noTurn=false
            
                      // print("change")
                       player?.texture = SKTexture(imageNamed: "knightStandard")
                    player?.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "knightStandard"),
                                                          size:SKTexture(imageNamed: "knightStandard").size())
                   player?.physicsBody?.allowsRotation=false
                   player?.physicsBody?.affectedByGravity=true
                  player?.physicsBody?.mass = 0.788289368152618
                   player?.physicsBody?.friction = 0.2
                   player?.physicsBody?.restitution = 0.2
                   player?.physicsBody?.linearDamping = 0.1
                   player?.physicsBody?.angularDamping = 0.1
                   
               }
            //   print(atan(data.velocity.y/data.velocity.x))
           
           }
       
     }
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
           let pointOfTouch = touch.location(in: self.camera!)
           if menu.contains(pointOfTouch){
               if let view = self.view {
                   // Load the SKScene from 'GameScene.sks'
                   if let scene = SKScene(fileNamed: "Menu") {
                       // Set the scale mode to scale to fit the window
                       scene.scaleMode = .aspectFill
                       
                       // Present the scene
                       view.presentScene(scene)
                   }
                   view.showsPhysics = false
                   view.ignoresSiblingOrder = true
                   
                   view.showsFPS = true
                   view.showsNodeCount = true //hi
               }
           }
            if(jump.contains(pointOfTouch)&&canJump==true){
                player?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 550))
            }
            if attack.contains(pointOfTouch){
                playerRunningRight(player:player!)
                playerRunningLeft(player: player!)
            }
        }
       
        

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    func playerRunningRight(player: SKSpriteNode){
        if(turnedRight==true||noTurn==true){
            let texture1 = SKTexture(imageNamed: "knightAttack1")
            let texture2 = SKTexture(imageNamed: "knightAttack2")
            let texture3 = SKTexture(imageNamed: "knightAttack3")
            let texture4 = SKTexture(imageNamed: "knightStandard")
            let animate = SKAction.animate(with: [texture1, texture2, texture3, texture4], timePerFrame: 0.125)
            player.run(animate, withKey:"attackingRightAction")
        }
        }
    func playerRunningLeft(player: SKSpriteNode){
        if(turnedLeft==true){
            let texture1 = SKTexture(imageNamed: "knightAttack1Left")
            let texture2 = SKTexture(imageNamed: "knightAttack2Left")
            let texture3 = SKTexture(imageNamed: "knightAttack3Left")
            let texture4 = SKTexture(imageNamed: "knightStandardLeft")
            let animate = SKAction.animate(with: [texture1, texture2, texture3, texture4], timePerFrame: 0.125)
            player.run(animate, withKey:"attackingLeftAction")
        }
        }
    
    override func update(_ currentTime: TimeInterval) {
        
      
       
//        print(player?.physicsBody?.velocity.dy)
        if((player?.physicsBody?.velocity.dy)! <= 0.1 && (player?.physicsBody?.velocity.dy)! >= -0.1){
            canJump = true
        }else{
            canJump = false
        }
        
        skelTimer+=1
        scene!.enumerateChildNodes(withName: "//skeleton") {
            (node, stop) in
            if (self.skelTimer%200<36){
                if ((node.xScale==1)||(node.xScale == -1)){
                    node.xScale=node.xScale*43/22
                }
                node.yScale=37/33
                node.run(SKAction.setTexture(self.attackSprites[Int(self.skelTimer/2)]))
//                node.physicsBody=SKPhysicsBody(texture: self.attackSprites[Int(self.skelTimer/2)], size:CGSize(width: 132*node.xScale, height: 192*node.yScale))
//                node.physicsBody?.allowsRotation=false
//                node.physicsBody?.affectedByGravity=true
//                node.physicsBody?.velocity.dx = 0
            } else if (node.physicsBody?.velocity.dx == 0){
//                node.physicsBody=SKPhysicsBody(texture: SKTexture(imageNamed: "s1"), size:CGSize(width: 132*node.xScale, height: 192*node.yScale))
//                node.physicsBody?.allowsRotation=false
//                node.physicsBody?.affectedByGravity=true
                if (node.xScale>0){
                    node.physicsBody?.velocity.dx = 80
                    node.xScale=1
//                    print("hi")
                } else {
                    node.physicsBody?.velocity.dx = -80
                    node.xScale = -1
//                    print("hi")
                }
                node.yScale=1
                
            }
            if (self.skelTimer==199){
                self.skelTimer=0
            }
//            print(node.physicsBody?.velocity.dx)
            if ((abs((node.physicsBody?.velocity.dx)!) < 5)&&(abs((node.physicsBody?.velocity.dx)!) > 0)){
//                self.skelV = -self.skelV
                node.physicsBody?.velocity.dx = 80*((node.physicsBody?.velocity.dx)!/abs((node.physicsBody?.velocity.dx)!))
                if ((node.physicsBody?.velocity.dx)! > 0){
                    node.xScale = 1
                } else {
                    node.xScale = -1
                }
                
            }
        }
    }
}
