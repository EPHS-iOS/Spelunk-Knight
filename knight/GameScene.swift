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
    let cam = SKCameraNode()
    var player : SKSpriteNode?
    var tileMap : SKTileMapNode?
    var tileSize : CGSize?
    var halfWidth : CGFloat?
    var halfHeight : CGFloat?
    var nodesListGround = [SKShapeNode]()
    var skelV=CGFloat(80)
    var skelTimer=0
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
      let js = AnalogJoystick(diameter: 300, colors: nil, images: (substrate: #imageLiteral(resourceName: "jSubstrate"), stick: #imageLiteral(resourceName: "jStick")))
        let ScreenSize = self.size
        js.position = CGPoint(x: cam.position.x+ScreenSize.width * -0.75, y: cam.position.y+ScreenSize.height * -0.75)
      js.zPosition = 3
      return js
    }()
    override func didMove(to view: SKView) {
        
        scene!.enumerateChildNodes(withName: "//skeleton") {
            (node, stop) in
            node.isPaused=true
            node.isPaused=false
            node.physicsBody?.velocity.dx=self.skelV
        }
        print(self.size)
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
         cam.addChild(menu)
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
        addChild(analogJoystick)
       
           analogJoystick.trackingHandler = { [unowned self] data in
               self.player?.position = CGPoint(x: (self.player?.position.x)! + (data.velocity.x * self.velocityMultiplier),
                                               y: (player?.position.y)!)
               
//             self.player?.zRotation = data.angular
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
        }
        

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        skelTimer+=1
        scene!.enumerateChildNodes(withName: "//skeleton") {
            (node, stop) in
//            node.position.x+=self.skelV
//            if (self.skelTimer%60==0){
//                self.skelTimer=0
//                self.skelV = -self.skelV
//                node.xScale = -node.xScale
//            }
            if (abs((node.physicsBody?.velocity.dx)!) < 5){

                self.skelV = -self.skelV
                node.physicsBody?.velocity.dx = self.skelV
                if ((node.physicsBody?.velocity.dx)! > 0){
                    node.xScale = 1
                } else {
                    node.xScale = -1
                }
                
            }
        }
    }
}
