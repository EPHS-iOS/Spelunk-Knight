//
//  GameScene.swift
//  knight
//
//  Created by 64011731 on 2/14/22.
//
//testing push-rishi

import SpriteKit
import GameplayKit
let defaul = UserDefaults.standard
struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    //      static let bullet   : UInt32 = 0b1       // 1
    static let player : UInt32 = 0b10//2
    static let map : UInt32 = 0b100//3
    static let campfire : UInt32 = 0b11
    static let spike : UInt32 = 0b101
    static let skeleton : UInt32 = 0b110
    static let boss : UInt32 = 0b111
    
    //        static let key : UInt32 = 0b100//4
    //        static let door : UInt32 = 0b101//5
    //        static let mapEdge : UInt32 = 0b110//6
    //        static let saw : UInt32 = 0b111//7
    //        static let laser : UInt32 = 0b1000//8
}
class GameScene: SKScene {
    var door : SKNode?
    
    //    var sk=Skeleton(pos: CGPoint(x: 500,y: 300), siz: CGSize(width: 132,height: 198))
    var menu = SKLabelNode(text: "menu")
    var health = SKLabelNode(text:"Health: 100")
    var healthImage : SKSpriteNode?
    var hp = defaul.integer(forKey: "hp")
    var maxHealth=5
    var isAttacking : Bool?
    let cam = SKCameraNode()
    var spawnPos : CGPoint?
    var player : SKSpriteNode?
    var left : SKSpriteNode?
    var right : SKSpriteNode?
    var tileMap : SKTileMapNode?
    var tileSize : CGSize?
    var fallingVelocity:CGFloat?
    var firstboss : FirstBoss?
    var boundLeft : SKNode?
    var boundRight : SKNode?
    
    var turnedRight : Bool?
    var turnedLeft : Bool?
    var noTurn : Bool?
    var halfWidth : CGFloat?
    var canJump : Bool?
    var halfHeight : CGFloat?
    var nodesListGround = [SKShapeNode]()
    var skeletons = [Skeleton]()
    var skelV=CGFloat(80)
    let jump = SKSpriteNode(imageNamed: "jumparrowKnight")
    let attack = SKSpriteNode(imageNamed:"jStick")
    var atk : Bool?
    var skelTimer=0
    var attackSprites :[SKTexture] = [SKTexture]()
    let velocityMultiplier: CGFloat = 0.17
    let ju: CGFloat = 950
    var x : CGFloat?
    var y : CGFloat?
    
    lazy var analogJoystick: AnalogJoystick = {
        scene?.view?.showsPhysics = false
        let js = AnalogJoystick(diameter: scene!.size.width/6, colors: nil, images: (substrate: #imageLiteral(resourceName: "jSubstrate"), stick: #imageLiteral(resourceName: "jStick")))
        let ScreenSize = self.size
        js.position = CGPoint(x:-(scene!.size.width)/3, y: -(scene!.size.height)/3)
        js.zPosition = 3
        cam.addChild(js)
        return js
    }()
    override func didMove(to view: SKView) {
        if hp == 0{
            hp = 5
        }
        isAttacking = false
        atk=false
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
        scene!.enumerateChildNodes(withName: "//rat") {
            (node, stop) in
            node.isPaused=true
            node.isPaused=false
            node.physicsBody?.velocity.dx=self.skelV
        }
        scene!.enumerateChildNodes(withName: "leftBound") {
            (node, stop) in
            
            self.boundLeft = node
            
        }
        scene!.enumerateChildNodes(withName: "rightBound") {
            (node, stop) in
            
            self.boundRight = node
            
        }
        scene!.enumerateChildNodes(withName: "boss") {
                  (node, stop) in
                  self.firstboss = FirstBoss(pos: node.position, siz: CGSize(width: 180,height: 238),leftnode:self.boundLeft!, rightnode:self.boundRight!)
      //            self.skeletons.append(Skeleton(pos: node.position, siz: CGSize(width: 132,height: 198)))
                  
              }
        
        //        print("spawnx"+(self.view?.scene?.name)!)
        view.isMultipleTouchEnabled=true
        setupJoystick()
        player = childNode(withName: "player") as?SKSpriteNode
        player?.physicsBody?.categoryBitMask=PhysicsCategory.player
        player?.physicsBody?.restitution = 0.0
        player?.physicsBody?.contactTestBitMask = PhysicsCategory.skeleton
        //reset spawn:
        defaul.setValue(Float((0)), forKey:  "spawnx"+(self.view?.scene?.name)!)
        defaul.setValue(Float((0)), forKey:  "spawny"+(self.view?.scene?.name)!)
        if(defaul.float(forKey: "spawnx"+(self.view?.scene?.name)!)==0.0){
            defaul.setValue(Float((player?.position.x)!), forKey:  "spawnx"+(self.view?.scene?.name)!)
        }
        if(defaul.float(forKey: "spawny"+(self.view?.scene?.name)!)==0.0){
            defaul.setValue(Float((player?.position.y)!), forKey:  "spawny"+(self.view?.scene?.name)!)
        }
        
        player!.position=CGPoint(x: CGFloat(defaul.float(forKey: "spawnx"+(self.view?.scene?.name)!)), y: CGFloat(defaul.float(forKey: "spawny"+(self.view?.scene?.name)!)))
        self.camera = cam
        
        cam.xScale=3
        cam.yScale=3
        self.addChild(cam)
        
        let constraint = SKConstraint.distance(SKRange(constantValue: 0), to: player!)
        
        camera!.constraints = [constraint]
        
        tileMap = (self.childNode(withName: "Tile Map Node") as? SKTileMapNode)!
        tileSize = tileMap?.tileSize
        halfWidth = CGFloat(tileMap!.numberOfColumns) / 2.0 * tileSize!.width
        halfHeight = CGFloat(tileMap!.numberOfRows) / 2.0 * tileSize!.height
        
        //        self.addChild(sk)
        
        menu.position = CGPoint(x:camera!.position.x-(scene!.size.width)/3, y: camera!.position.y+(scene!.size.width)/5)
        menu.zPosition = 3
        menu.fontSize = scene!.size.width/19
        menu.fontColor = SKColor.white
        menu.alpha = 0.8
        
        health.position = CGPoint(x:camera!.position.x+scene!.size.width/38, y: camera!.position.y+(scene!.size.width)/5)
        health.zPosition = 3
        health.fontSize = scene!.size.width/19
        health.fontColor = SKColor.white
        health.alpha = 0.8
        health.text="x"+String(hp)
        cam.addChild(health)
        scene!.enumerateChildNodes(withName: "door") {
            (node, stop) in
            
            self.door=node
            
        }
        firstboss?.physicsBody?.categoryBitMask=PhysicsCategory.boss
               firstboss?.physicsBody?.contactTestBitMask = PhysicsCategory.player
               self.addChild(firstboss!)
               
               
        
        scene!.enumerateChildNodes(withName: "skelly") {
            (node, stop) in
            self.skeletons.append(Skeleton(pos: node.position, siz: CGSize(width: 132,height: 198)))
        }
        for skelly in skeletons{
            skelly.physicsBody?.categoryBitMask=PhysicsCategory.skeleton
            skelly.physicsBody?.contactTestBitMask = PhysicsCategory.player
            self.addChild(skelly)
        }
        healthImage = SKSpriteNode(texture: SKTexture(imageNamed: "heart"), size: CGSize(width: scene!.size.width/19,height: scene!.size.width/19))
        healthImage!.zPosition=5
        healthImage!.position=CGPoint(x: camera!.position.x-scene!.size.width/38/*+((4*(scene!.size.width))/10)*/, y: camera!.position.y+(scene!.size.width)/5+scene!.size.width/38)
        cam.addChild(healthImage!)
        
        cam.addChild(menu)
        //        cam.addChild(left!)
        //        cam.addChild(right!)
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
        fallingVelocity=player?.physicsBody?.velocity.dy
        for col in 0..<tileMap!.numberOfColumns {
            for row in 0..<tileMap!.numberOfRows {
                let tileDefinition = tileMap!.tileDefinition(atColumn: col, row: row)
                let isCobblestone = tileDefinition?.userData?["Cobblestone"] as? Bool
                let isCampfire = tileDefinition?.userData?["checkpoint"] as? Bool
                let isSpike = tileDefinition?.userData?["spike"] as? Bool
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
                    tileNode.physicsBody?.restitution=0
                    tileNode.physicsBody?.collisionBitMask = PhysicsCategory.none
                    //tileNode.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
                    tileNode.physicsBody?.contactTestBitMask = PhysicsCategory.player
                    
                    tileMap!.addChild(tileNode)
                    nodesListGround.append(tileNode)
                }
                if (isCampfire ?? false){
                    x = CGFloat(col) * tileSize!.width - halfWidth!
                    y = CGFloat(row) * tileSize!.height - halfHeight!
                    let rect = CGRect(x: 0, y: 0, width: tileSize!.width, height: tileSize!.height)
                    let tileNode = SKShapeNode(rect: rect)
                    tileNode.position = CGPoint(x: x!, y: y!)
                    tileNode.physicsBody = SKPhysicsBody.init(rectangleOf: tileDefinition!.size, center: CGPoint(x: tileDefinition!.size.width / 2.0, y: tileDefinition!.size.height / 2.0))
                    tileNode.physicsBody?.isDynamic = false
                    //tileNode.physicsBody?.usesPreciseCollisionDetection = true
                    tileNode.alpha=0
                    tileNode.physicsBody?.categoryBitMask = PhysicsCategory.campfire
                    tileNode.physicsBody?.friction = 0
                    tileNode.physicsBody?.collisionBitMask = PhysicsCategory.none
                    //tileNode.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
                    tileNode.physicsBody?.contactTestBitMask = PhysicsCategory.player
                    
                    
                    tileMap!.addChild(tileNode)
                    nodesListGround.append(tileNode)
                }
                if (isSpike ?? false) {
                    x = CGFloat(col) * tileSize!.width - halfWidth!
                    y = CGFloat(row) * tileSize!.height - halfHeight!
                    let rect = CGRect(x: 0, y: 0, width: tileSize!.width, height: tileSize!.height)
                    let tileNode = SKShapeNode(rect: rect)
                    tileNode.position = CGPoint(x: x!, y: y!)
                    tileNode.physicsBody = SKPhysicsBody.init(rectangleOf: tileSize!, center: CGPoint(x: tileSize!.width / 2.0, y: tileSize!.height / 2.0))
                    tileNode.physicsBody?.isDynamic = false
                    
                    //tileNode.physicsBody?.usesPreciseCollisionDetection = true
                    tileNode.alpha=0
                    tileNode.physicsBody?.categoryBitMask = PhysicsCategory.spike
                    tileNode.physicsBody?.friction = 0
                    tileNode.physicsBody?.restitution=0
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
        //        print(player?.physicsBody?.velocity.dy)
        analogJoystick.trackingHandler = { [unowned self] data in
            self.player?.position = CGPoint(x: (self.player?.position.x)! + (data.velocity.x * self.velocityMultiplier),
                                            y: (player?.position.y)!)
            if(data.velocity.x<0&&turnedLeft==false){
                var fallingv = fallingVelocity
                turnedLeft = true
                turnedRight = false
                noTurn=false
                playerRunningLeft(player: player!)
                
                
                //  print("changeleft")
                
                player?.xScale = 1
                player?.physicsBody?.allowsRotation=false
                player?.physicsBody?.velocity.dy=fallingv!
                player?.physicsBody?.affectedByGravity=true
                player?.physicsBody?.mass = 0.788289368152618
                player?.physicsBody?.friction = 0.2
                player?.physicsBody?.restitution = 0.0
                player?.physicsBody?.linearDamping = 0.1
                player?.physicsBody?.angularDamping = 0.1
                player?.physicsBody?.categoryBitMask=PhysicsCategory.player
                player?.physicsBody?.collisionBitMask=PhysicsCategory.map
                //                player?.physicsBody?.contactTestBitMask=PhysicsCategory.campfire | PhysicsCategory.skeleton
                //                sk.physicsBody?.collisionBitMask=PhysicsCategory.map | PhysicsCategory.player
                //                   player?.physicsBody?.velocity.dy=vall!
            }
            if(data.velocity.x>0&&turnedRight==false){
                var fallingv = fallingVelocity
                turnedRight = true
                turnedLeft = false
                noTurn=false
                playerRunning(player: player!)
                // print("change")
                //  print("changeleft")
                
                player?.physicsBody?.allowsRotation=false
                player?.physicsBody?.velocity.dy=fallingv!
                player?.physicsBody?.affectedByGravity=true
                player?.physicsBody?.mass = 0.788289368152618
                player?.physicsBody?.friction = 0.2
                player?.physicsBody?.restitution = 0.0
                player?.physicsBody?.linearDamping = 0.1
                player?.physicsBody?.angularDamping = 0.1
                player?.physicsBody?.categoryBitMask=PhysicsCategory.player
                player?.physicsBody?.collisionBitMask=PhysicsCategory.map
                //                player?.physicsBody?.contactTestBitMask=PhysicsCategory.campfire | PhysicsCategory.skeleton
                //                sk.physicsBody?.collisionBitMask=PhysicsCategory.map | PhysicsCategory.player
                //                   player?.physicsBody?.velocity.dy=vall!
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
                player?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: ju))
            }
            if attack.contains(pointOfTouch){
                playerAttacking(player:player!)
                playerAttackingLeft(player:player!)
                //                for i in player!.physicsBody!.allContactedBodies(){
                //                    if (i.categoryBitMask==PhysicsCategory.skeleton){
                //
                //                        attackEnemy(enemy: sk)
                //
                //
                //                    }
                //                }
            }
        }
        
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    func playerAttacking(player: SKSpriteNode){
        if(turnedRight==true||noTurn==true){
            isAttacking=true
            atk=true
            let texture1 = SKTexture(imageNamed: "knightAttack1")
            let texture2 = SKTexture(imageNamed: "knightAttack2")
            let texture3 = SKTexture(imageNamed: "knightAttack3")
            let texture4 = SKTexture(imageNamed: "knightStandard")
            let actionBlock = SKAction.run({
                //print("change")
                self.isAttacking = false
                self.atk=false
            })
            let animate = SKAction.animate(with: [texture1, texture2, texture3, texture4], timePerFrame: 0.125)
            let sequence = SKAction.sequence([animate,actionBlock])
            
            player.run(sequence, withKey:"attackingRightAction")
            
            
        }
        
    }
    func playerAttackingLeft(player: SKSpriteNode){
        if(turnedLeft==true){
            isAttacking=true
            atk=true
            let texture1 = SKTexture(imageNamed: "knightAttack1Left")
            let texture2 = SKTexture(imageNamed: "knightAttack2Left")
            let texture3 = SKTexture(imageNamed: "knightAttack3Left")
            let texture4 = SKTexture(imageNamed: "knightStandardLeft")
            let actionBlock = SKAction.run({
                //Do what you want here
                self.isAttacking = false
                self.atk=false
            })
            let animate = SKAction.animate(with: [texture1, texture2, texture3, texture4], timePerFrame: 0.125)
            let sequence = SKAction.sequence([animate,actionBlock])
            
            player.run(sequence, withKey:"attackingLeftAction")
        }
        
    }
    func playerRunning(player: SKSpriteNode){
        if(turnedRight==true){
            let texture1 = SKTexture(imageNamed: "knightRun1")
            let texture2 = SKTexture(imageNamed: "knightRun2")
            let texture3 = SKTexture(imageNamed: "knightRun3")
            let texture4 = SKTexture(imageNamed: "knightRun4")
            let texture5 = SKTexture(imageNamed: "knightRun5")
            let animate = SKAction.animate(with: [texture1, texture2, texture3, texture4,texture5,texture4, texture3, texture2], timePerFrame: 0.200)
            
            player.run(SKAction.repeatForever(animate), withKey: "runRight")
        }
    }
    func attackEnemy(enemy: Skeleton){
        if(enemy.position.x<player!.position.x && turnedLeft==true&&atk==true){
            enemy.health -= 1
            //            print("hit")
            atk=false
        }
        if(enemy.position.x>player!.position.x && turnedRight==true&&atk==true){
            enemy.health -= 1
            //            print("hit")
            atk=false
        }
        if(enemy.health == 0){
            enemy.position.x-=10000
            enemy.removeFromParent()
            
        }
    }
    func playerRunningLeft(player: SKSpriteNode){
        if(turnedLeft==true){
            let texture1 = SKTexture(imageNamed: "knightRun1Left")
            let texture2 = SKTexture(imageNamed: "knightRun2Left")
            let texture3 = SKTexture(imageNamed: "knightRun3Left")
            let texture4 = SKTexture(imageNamed: "knightRun4Left")
            let texture5 = SKTexture(imageNamed: "knightRun5Left")
            let animate = SKAction.animate(with: [texture1, texture2, texture3, texture4,texture5,texture4, texture3, texture2], timePerFrame: 0.200)
            player.run(SKAction.repeatForever(animate), withKey:"runLeft")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        firstboss!.update()
        defaul.setValue(hp, forKey: "hp")
        if(analogJoystick.stick.position.x==0.0&&isAttacking==false){
            noTurn = true
            let texture1 = SKTexture(imageNamed: "knightStandard")
            player!.run(SKAction.animate(with:[texture1], timePerFrame:0.1))
            player?.texture = SKTexture(imageNamed: "knightStandard")
            
        }
        
        
        fallingVelocity=player?.physicsBody?.velocity.dy
        for sk in skeletons{
            sk.update()
            if(player!.frame.intersects(sk.frame)){
                //            print("hi")
                if ((((player?.position.x)!<=sk.position.x)&&(sk.xScale == -1))||(((player?.position.x)!>=sk.position.x)&&(sk.xScale==1))){
                    if (hp>0&&sk.atk==true){
                        hp -= 1
                        health.text="x"+String(hp)
                        sk.atk=false
                    }
                }
                attackEnemy(enemy: sk)
            }
        }
        for i in player!.physicsBody!.allContactedBodies(){
            if (i.categoryBitMask==PhysicsCategory.campfire){
                defaul.setValue(Float((player?.position.x)!), forKey:  "spawnx"+(self.view?.scene?.name)!)
                defaul.setValue(Float((player?.position.y)!), forKey:  "spawny"+(self.view?.scene?.name)!)
                if (hp<maxHealth){
                    hp+=1
                    health.text="x"+String(hp)
                }
                
            }
            if (i.categoryBitMask==PhysicsCategory.spike){
                player?.position=CGPoint(x: CGFloat(defaul.float(forKey: "spawnx"+(self.view?.scene?.name)!)), y: CGFloat(defaul.float(forKey: "spawny"+(self.view?.scene?.name)!)))
                //                if (hp>0){
                //                    hp -= 1
                //                    health.text="x"+String(hp)
                //                }
                hp=5
            }
            //            if (i.categoryBitMask==PhysicsCategory.skeleton){
            //                print("hi")
            //                if (hp>0){
            //                    hp -= 1
            //                    health.text="x"+String(hp)
            //                }
            //
            //
            //                attackEnemy(enemy: sk)
            //
            //
            //            }
        }
        //        print(player?.physicsBody?.velocity.dy)
        
        //        print(player?.physicsBody?.velocity.dy)
        if((player?.physicsBody?.velocity.dy)! <= 0.1 && (player?.physicsBody?.velocity.dy)! >= -0.1){
            canJump = true
        }else{
            canJump = false
        }
        if (door != nil){
            if(player!.frame.intersects(door!.frame)==true){
                if let view = self.view {
                    if self.view?.scene!.name=="GameScene"{
                        analogJoystick.disabled=true
                        // Load the SKScene from 'GameScene.sks'
                        defaul.setValue(Float((0)), forKey:  "spawnx"+"ge")
                        defaul.setValue(Float((0)), forKey:  "spawny"+"ge")
                        defaul.setValue("ge", forKey: "scene")
                        if let scene = SKScene(fileNamed: "ge") {
                            // Set the scale mode to scale to fit the window
                            scene.scaleMode = .aspectFit
                            
                            // Present the scene
                            view.presentScene(scene)
                        }
                        view.showsPhysics = false
                        view.ignoresSiblingOrder = true
                        
                        view.showsFPS = true
                        view.showsNodeCount = true //hi
                    } else {
                        analogJoystick.disabled=true
                        // Load the SKScene from 'GameScene.sks'
                        defaul.setValue(Float((0)), forKey:  "spawnx"+"GameScene")
                        defaul.setValue(Float((0)), forKey:  "spawny"+"GameScene")
                        defaul.setValue("GameScene", forKey: "scene")
                        if let scene = SKScene(fileNamed: "GameScene") {
                            // Set the scale mode to scale to fit the window
                            scene.scaleMode = .aspectFit
                            
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
