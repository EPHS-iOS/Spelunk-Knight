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
    static let bullet : UInt32 = 0b1000
//    static let bat : UInt32 = 0b1001
    //        static let key : UInt32 = 0b100//4
    //        static let door : UInt32 = 0b101//5
    //        static let mapEdge : UInt32 = 0b110//6
    //        static let saw : UInt32 = 0b111//7
    //        static let laser : UInt32 = 0b1000//8
}
class GameScene: SKScene {
    var counthits = false
   var hitvisible = 0
    var turnedRight : Bool?
    var canNotPass:Bool?
    var canNotPassSkeleton: Bool?
    var turnedLeft : Bool?
    var noTurn : Bool?
    var gunEnable=defaul.bool(forKey: "gunEnable")
    var swordEnable = defaul.bool(forKey: "swordEnable")
    var carlos : SKNode?
    var steve : SKNode?
    var door : SKNode?
    var canShoot = true
    var canShootTimer=0
    var endGameTimerStart=false
    var endgameTimer=0
    var batCanAttack = true
    var ratCanAttack = true
    //    var sk=Skeleton(pos: CGPoint(x: 500,y: 300), siz: CGSize(width: 132,height: 198))
    var menu = SKLabelNode(text: "menu")
    var timer = Timer()
    var batTimer = Timer()
    var health = SKLabelNode(text:"Health: 100")
    var healthImage : SKSpriteNode?
    var hp = defaul.integer(forKey: "hp")
    var maxHealth=5
    var bullets = 5
    var isAttacking : Bool?
    var isAttacking2 : Bool?
    var atk2 : Bool?
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
    var gun: Gun?
    
    var halfWidth : CGFloat?
    var canJump : Bool?
    var halfHeight : CGFloat?
    var bulletsShot = [Bullet]()
    var nodesListGround = [SKShapeNode]()
    var skeletons = [Skeleton]()
    var bats = [Bat]()
    var rats = [Rat]()
    var skelV=CGFloat(80)
    let jump = SKSpriteNode(imageNamed: "jumparrowKnight")
    let attack = SKSpriteNode(imageNamed:"fist")
    let shoot = SKSpriteNode(imageNamed: "shoot")
    let sword = SKSpriteNode(imageNamed: "sword")
    let hit = SKSpriteNode(imageNamed: "hit")
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
//        gunEnable=true
//        swordEnable=true
        
        canNotPass=true
        canNotPassSkeleton=true
        
        let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        let batTimer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire2), userInfo: nil, repeats: true)
        let ratTimer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire3), userInfo: nil, repeats: true)
        
        if hp <= 0{
            
            hp = 5
            
        }
        isAttacking = false
        isAttacking2 = false
        atk=false
        atk2 = false
        turnedLeft = false
        turnedRight = false
        if(turnedLeft == false && turnedRight == false){
            noTurn = true
        }else{
            noTurn=false
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
        gun=Gun(char: player!)
        if gunEnable{
            self.addChild(gun!)
        }
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
        player!.xScale=1
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
        hit.alpha = 0
        hit.position = CGPoint(x:camera!.position.x+(scene!.size.width)/4, y: camera!.position.y-(scene!.size.width)/5.5)
        hit.zPosition = 10
        hit.size=CGSize(width:scene!.size.width/7,height:scene!.size.width/8)
        addChild(hit)

        scene!.enumerateChildNodes(withName: "Carlos") {
                   (node, stop) in
                   self.carlos=node
               }
               scene!.enumerateChildNodes(withName: "Steve") {
                   (node, stop) in
                   
                   self.steve=node
                   
               }
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
        scene!.enumerateChildNodes(withName: "bat") {
            (node, stop) in
            self.bats.append(Bat(pos: node.position, siz: CGSize(width: 103*1.5,height: 67*1.5)))
        }
        for bat in bats {
            bat.physicsBody?.categoryBitMask=PhysicsCategory.skeleton
            bat.physicsBody?.contactTestBitMask = PhysicsCategory.player
            bat.physicsBody?.contactTestBitMask = PhysicsCategory.map
            self.addChild(bat)
        }
        scene!.enumerateChildNodes(withName: "rat") {
            (node, stop) in
            self.rats.append(Rat(pos: node.position, siz: CGSize(width: 140,height: 56)))
        }
        for rat in rats {
            rat.physicsBody?.categoryBitMask=PhysicsCategory.skeleton
            rat.physicsBody?.contactTestBitMask = PhysicsCategory.player
            rat.physicsBody?.contactTestBitMask = PhysicsCategory.map
            self.addChild(rat)
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
        shoot.position = CGPoint(x:camera!.position.x+(scene!.size.width)/2.8, y: camera!.position.y-(scene!.size.width)/4)
        shoot.zPosition = 3
        shoot.size = CGSize(width:scene!.size.width/15,height:scene!.size.width/15)
        shoot.alpha = 1
        sword.position = CGPoint(x:camera!.position.x+(scene!.size.width)/2.8, y: camera!.position.y-(scene!.size.width)/11)
          sword.zPosition = 5
          sword.size = CGSize(width:scene!.size.width/15,height:scene!.size.width/15)
          sword.alpha = 1
        if gunEnable{
            cam.addChild(shoot)
        }
        if swordEnable{
            cam.addChild(sword)
        }
        
       // cam.addChild(sword)
    
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
    @objc func fire()
    {
        
        let randomInt = Int.random(in: 1..<10)
                
                  
                   if(randomInt==5||randomInt==6||randomInt==7){
                   firstboss!.jump()
                   }else{
                       firstboss!.attack1()
                   }

             
         }
    @objc func fire2(){
        if(batCanAttack==true){
            batCanAttack=false
        }else{
            batCanAttack=true
        }
    }
    @objc func fire3(){
        if(ratCanAttack==true){
            ratCanAttack=false
        }else{
            ratCanAttack=true
        }
    }
    func setupJoystick() {
        //addChild(analogJoystick)
        //        print(player?.physicsBody?.velocity.dy)
        analogJoystick.trackingHandler = { [unowned self] data in
            if(self.isAttacking2==false&&self.endGameTimerStart==false){
            self.player?.position = CGPoint(x: (self.player?.position.x)! + (data.velocity.x * self.velocityMultiplier),
                                            y: (player?.position.y)!)
            }
            if(data.velocity.x<0&&(turnedLeft==false||noTurn==true)){
                var fallingv = fallingVelocity
                turnedLeft = true
                turnedRight = false
                noTurn=false
                playerRunning(player: player!)
                player?.xScale = -1
                
                
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
            if(data.velocity.x>0&&(turnedRight==false||noTurn==true)){
                var fallingv = fallingVelocity
                turnedRight = true
                turnedLeft = false
                noTurn=false
                playerRunning(player: player!)
                player?.xScale = 1
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
                        scene.scaleMode = .aspectFit
                        
                        // Present the scene
                        view.presentScene(scene)
                    }
                    view.showsPhysics = false
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = false
                    view.showsNodeCount = false //hi
                }
            }
            if(jump.contains(pointOfTouch)&&canJump==true){
                player?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: ju))
            }
            if attack.contains(pointOfTouch){
                           
                           if(isAttacking==false){
                               playerAttacking(player:player!)
                           }
                           //                for i in player!.physicsBody!.allContactedBodies(){
                           //                    if (i.categoryBitMask==PhysicsCategory.skeleton){
                           //
                           //                        attackEnemy(enemy: sk)
                           //
                           //
                           //                    }
                           //                }
                       }
            if sword.contains(pointOfTouch) && swordEnable{
                      if(isAttacking2==false){
                      playerAttackingSword(player:player!)
                      }
                  }

            if shoot.contains(pointOfTouch) && gunEnable{
                
                if (canShoot&&bullets>0){
                    bulletsShot.append(Bullet(pos: CGPoint(x: gun!.position.x+(gun!.xScale*(gun?.size.width)!)/2, y: gun!.position.y+(gun?.size.height)!/2-5), direction: gun!.xScale))
                    bullets-=1
                    bulletsShot.last?.physicsBody?.isDynamic = false // 2
                    bulletsShot.last?.physicsBody?.categoryBitMask = PhysicsCategory.bullet // 3
                    bulletsShot.last?.physicsBody?.contactTestBitMask = PhysicsCategory.all// 4
                    bulletsShot.last?.physicsBody?.collisionBitMask = PhysicsCategory.all
                    bulletsShot.last?.physicsBody = SKPhysicsBody(texture: (bulletsShot.last?.texture!)!, alphaThreshold: 0.5, size: bulletsShot.last!.size)
                    bulletsShot.last?.physicsBody?.contactTestBitMask = PhysicsCategory.all // 4
                    bulletsShot.last?.physicsBody?.allowsRotation=false
                    bulletsShot.last?.physicsBody?.affectedByGravity=false
                    self.addChild(bulletsShot.last!)
                }
                canShoot=false
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
      
            isAttacking=true
            atk=true
             // let texture1 = SKTexture(imageNamed: "knightPunch1")
              let texture2 = SKTexture(imageNamed: "knightPunch2")
              let texture3 = SKTexture(imageNamed: "knightPunch3")
              let texture4 = SKTexture(imageNamed: "knightPunch4")
              let texture5 = SKTexture(imageNamed: "knightPunch5")
              let texture6 = SKTexture(imageNamed: "knightPunch6")
              let texture7 = SKTexture(imageNamed: "knightPunch7")
              let texture8 = SKTexture(imageNamed: "knightStandard")
              let actionBlock = SKAction.run({
                //print("change")
                self.isAttacking = false
                self.atk=false
              })
              let animate = SKAction.animate(with: [texture2, texture3, texture4, texture5, texture6, texture7, texture8], timePerFrame: 0.125)
              let sequence = SKAction.sequence([animate,actionBlock])
        if(analogJoystick.stick.position.x>0){
            player.xScale = 1
        }
        if(analogJoystick.stick.position.x<0){
           // print("hididthis")
            player.xScale = -1
        }
            
        player.run(sequence, withKey:"attackingRightAction")
        
    }
    func playerAttackingSword(player: SKSpriteNode){
      
            isAttacking2=true
           atk2=true
             // let texture1 = SKTexture(imageNamed: "knightPunch1")
              let texture2 = SKTexture(imageNamed: "knightAttack1")
              let texture3 = SKTexture(imageNamed: "knightAttack2")
              let texture4 = SKTexture(imageNamed: "knightAttack3")
              let texture5 = SKTexture(imageNamed: "knightStandard")
              let texture8 = SKTexture(imageNamed: "knightStandard")
              let actionBlock = SKAction.run({
                //print("change")
                self.isAttacking2 = false
                self.atk2 = false
              })
              let animate = SKAction.animate(with: [texture2, texture3, texture4, texture5,  texture8], timePerFrame: 0.125)
              let sequence = SKAction.sequence([animate,actionBlock])
        if(analogJoystick.stick.position.x>0){
            player.xScale = 1
        }
        if(analogJoystick.stick.position.x<0){
           // print("hididthis")
            player.xScale = -1
        }
            
        player.run(sequence, withKey:"attackingActionSword")
       
            
        
        
    }
//    func playerAttackingLeft(player: SKSpriteNode){
//        if(turnedLeft==true){
//            isAttacking=true
//            atk=true
//            let texture1 = SKTexture(imageNamed: "knightAttack1Left")
//            let texture2 = SKTexture(imageNamed: "knightAttack2Left")
//            let texture3 = SKTexture(imageNamed: "knightAttack3Left")
//            let texture4 = SKTexture(imageNamed: "knightStandardLeft")
//            let actionBlock = SKAction.run({
//                //Do what you want here
//                self.isAttacking = false
//                self.atk=false
//            })
//            let animate = SKAction.animate(with: [texture1, texture2, texture3, texture4], timePerFrame: 0.125)
//            let sequence = SKAction.sequence([animate,actionBlock])
//
//            player.run(sequence, withKey:"attackingLeftAction")
//        }
//
//    }
    func playerRunning(player: SKSpriteNode){
        if(analogJoystick.stick.position.x>0){
            player.xScale = 1
        }
        if(analogJoystick.stick.position.x<0){
//            print("hididthis")
            player.xScale = -1
        }
        
        
            let texture1 = SKTexture(imageNamed: "knightRun1")
            let texture2 = SKTexture(imageNamed: "knightRun2")
            let texture3 = SKTexture(imageNamed: "knightRun3")
            let texture4 = SKTexture(imageNamed: "knightRun4")
            let texture5 = SKTexture(imageNamed: "knightRun5")
            let animate = SKAction.animate(with: [texture1, texture2, texture3, texture4,texture5,texture4, texture3, texture2], timePerFrame: 0.150)
            
            player.run(SKAction.repeatForever(animate), withKey: "runRight")
           
        
    }
    func attackEnemy(enemy: Skeleton){
        if(enemy.position.x<player!.position.x && turnedLeft==true&&atk==true){
            //print("atackHERE")
            enemy.health -= 1
            hitmarker(place:enemy.position)
            
            //            print("hit")
            atk=false
           
        }
        if(enemy.position.x>player!.position.x && turnedRight==true&&atk==true){
           // print("atackHERE")
            enemy.health -= 1
            hitmarker(place:enemy.position)
                
            //            print("hit")
            atk=false
            
        }
        if(enemy.health == 0){
            enemy.position.x-=10000
            enemy.removeFromParent()
           
        }
    }
    func attackEnemy(enemy: Bat){
        if(enemy.position.x<player!.position.x && (turnedLeft==true) && atk==true){
            
            enemy.health -= 1
            hitmarker(place:enemy.position)
            
            
            //            print("hit")
            atk=false
            
        }
        if(enemy.position.x>player!.position.x && (turnedRight==true)&&atk==true){
            
            enemy.health -= 1
            hitmarker(place:enemy.position)
            //            print("hit")
            atk=false
            
        }
        if(enemy.health == 0){
            enemy.position.x-=10000
            enemy.removeFromParent()
            
        }
    }
    func attackEnemy(enemy: Rat){
        if(enemy.position.x<player!.position.x && (turnedLeft==true) && atk==true){
            
            enemy.health -= 1
            hitmarker(place:enemy.position)
            
            
            //            print("hit")
            atk=false
            
        }
        if(enemy.position.x>player!.position.x && (turnedRight==true)&&atk==true){
            
            enemy.health -= 1
            hitmarker(place:enemy.position)
            //            print("hit")
            atk=false
            
        }
        if(enemy.health == 0){
            enemy.position.x-=10000
            enemy.removeFromParent()
            
        }
    }
    func attackEnemySword(enemy: Bat){
        if(enemy.position.x<player!.position.x && turnedLeft==true&&atk2==true){
            enemy.health -= 1
            hitmarker(place:enemy.position)
            //            print("hit")
            atk2=false
            
        }
        if(enemy.position.x>player!.position.x && turnedRight==true&&atk2==true){
            enemy.health -= 1
            hitmarker(place:enemy.position)
            //            print("hit")
            atk2=false
            
        }
        if(enemy.health == 0){
            enemy.position.x-=10000
            enemy.removeFromParent()
            
        }
    }
    func attackEnemySword(enemy: Rat){
        if(enemy.position.x<player!.position.x && turnedLeft==true&&atk2==true){
            enemy.health -= 1
            //            print("hit")
            atk2=false
            hitmarker(place:enemy.position)
            
        }
        if(enemy.position.x>player!.position.x && turnedRight==true&&atk2==true){
            enemy.health -= 1
            //            print("hit")
            atk2=false
            hitmarker(place:enemy.position)
            
        }
        if(enemy.health == 0){
            enemy.position.x-=10000
            enemy.removeFromParent()
            
        }
    }
    func attackEnemySword(enemy: Skeleton){
        if(enemy.position.x<player!.position.x && turnedLeft==true&&atk2==true){
            enemy.health -= 1
            hitmarker(place:enemy.position)
            //            print("hit")
            atk2=false
           
        }
        if(enemy.position.x>player!.position.x && turnedRight==true&&atk2==true){
            enemy.health -= 1
            hitmarker(place:enemy.position)
            //            print("hit")
            atk2=false
            
        }
        if(enemy.health == 0){
            enemy.position.x-=10000
            enemy.removeFromParent()
            
        }
    }
    func attackBoss(enemy: FirstBoss){
        if(enemy.position.x<player!.position.x && turnedLeft==true&&atk==true){
            enemy.health -= 1
            //            print("hit")
            atk=false
            hitmarker(place:enemy.position)
          
        }
        if(enemy.position.x>player!.position.x && turnedRight==true&&atk==true){
            enemy.health -= 1
            //            print("hit")
            atk=false
            hitmarker(place:enemy.position)
            
        }
        if(enemy.health == 0){
            enemy.position.x-=10000
            enemy.removeFromParent()
            
        }
    }
    func attackBossSword(enemy: FirstBoss){
        if(enemy.position.x<player!.position.x && turnedLeft==true&&atk2==true){
            enemy.health -= 1
            //            print("hit")
            atk2=false
            hitmarker(place:enemy.position)
         // print("BOSSHITSWORD")
        }
        if(enemy.position.x>player!.position.x && turnedRight==true&&atk2==true){
            enemy.health -= 1
            //            print("hit")
            atk2=false
            hitmarker(place:enemy.position)
         //   print("BOSSHITSWORD")
            
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
    func hitmarker(place: CGPoint){
        hitvisible = 0
        hit.alpha = 1
        counthits = true
        hit.position.x = place.x
      hit.position.y = place.y
        
       
        //print("alpha change")
    
        
        
//        print("playerpos")
//        print(player?.position)
//         print("hitpos")
//         print(hit.position)

        
    }
    override func update(_ currentTime: TimeInterval) {
        if(counthits == true){
                  hitvisible += 1
              }
              if(hitvisible == 10){
                  hit.alpha = 0
                  counthits = false
                  hitvisible = 0
              }

//       print("first")
//        print(canNotPassSkeleton)
//        print("second")
//        print(canNotPass)
        
        if(endGameTimerStart==true){
            analogJoystick.stick.position.x=0.0
            analogJoystick.stick.position.y=0.0
            
        }
        
        
        if canShoot && gunEnable && shoot.parent==nil{
            cam.addChild(shoot)
        } else if !canShoot && !(shoot.parent==nil){
            shoot.removeFromParent()
        }
        if !canShoot{
            canShootTimer+=1
            if canShootTimer==40{
                canShootTimer=0
                canShoot.toggle()
            }
        }
        
        if(analogJoystick.stick.position.x>0){
//            print("updatexscale")
            player!.xScale = 1
        }
        if(analogJoystick.stick.position.x<0){
            player!.xScale = -1
        }
//        if(turnedLeft==true && player?.xScale != -1){
//        player?.xScale = -1
//        }
//        print(player!.xScale)
        //print(turnedLeft)
//        print(player?.physicsBody?.allContactedBodies().isEmpty)
        for b in bulletsShot{
            b.setPosition()
//            b.setPosition(xScale: gun?.xScale)
            for c in b.physicsBody!.allContactedBodies(){
                
                if c.node?.physicsBody?.categoryBitMask==PhysicsCategory.skeleton{
                    for sk in skeletons{
                        if sk.physicsBody==c{
                            sk.health-=1
                            hitmarker(place:sk.position)
                        }
                        if sk.health==0{
//                            c.node?.position.x-=10000
//                            c.node?.removeFromParent()
                            sk.position.x-=10000
                            sk.alpha=0
                            sk.removeFromParent()
                            
                        }
                    }
                    for bat in bats {
                        if bat.physicsBody==c{
                            bat.health-=1
                            hitmarker(place:bat.position)
                        }
                        if bat.health==0{
//                            c.node?.position.x-=10000
//                            c.node?.removeFromParent()
                            bat.position.x-=10000
                            bat.alpha=0
                            bat.removeFromParent()
                        }
                    }
                    for rat in rats {  //here
                        if rat.physicsBody==c{
                            rat.health-=1
                            hitmarker(place:rat.position)
                        }
                        if rat.health==0{
//                            c.node?.position.x-=10000
//                            c.node?.removeFromParent()
                            rat.position.x-=10000
                            rat.alpha=0
                            rat.removeFromParent()
                        }
                    }
                    b.removeFromParent()
                }
                if c.node?.physicsBody?.categoryBitMask==PhysicsCategory.boss{
                   firstboss!.health-=1
                    hitmarker(place:firstboss!.position)
                    if firstboss!.health==0{
                        c.node?.position.x-=10000
                        c.node?.removeFromParent()
                    }
                }
                else if !(c.node?.physicsBody?.categoryBitMask==PhysicsCategory.player){
                    b.removeFromParent()
                }
            }
        }
        gun?.setPosition()
        firstboss!.update()
        defaul.setValue(hp, forKey: "hp")
        if(analogJoystick.stick.position.x==0.0&&isAttacking==false&&isAttacking2==false){
            noTurn = true
            let texture1 = SKTexture(imageNamed: "knightStandard")
            player!.run(SKAction.animate(with:[texture1], timePerFrame:0.1))
            player?.texture = SKTexture(imageNamed: "knightStandard")
            
        }
        
        
        fallingVelocity=player?.physicsBody?.velocity.dy
        for rat in rats{
            rat.update()
        }
        for bat in bats{
            if(bat.frame.intersects(player!.frame)){
                attackEnemy(enemy: bat)
                
                bat.playercontact=true
            }else{
                bat.playercontact=false
            }
            if(abs(player!.position.x-bat.position.x)<=200&&abs(player!.position.y-bat.position.y)<=200){
                attackEnemySword(enemy: bat)
            }
            
            
            bat.update()
            
            for b in bat.physicsBody!.allContactedBodies(){
                
                if b.categoryBitMask==PhysicsCategory.player{
                    
                    // bat.position.x+=2*bat.sp
                    if (hp>0&&batCanAttack==true){
                        hp -= 1
                        batCanAttack = false
                        hitmarker(place:player!.position)
//                        print("yes")
                        health.text="x"+String(hp)
                        defaul.setValue(hp, forKey: "hp")
                        if hp==0{
                            
                            
                            
                            endGameTimerStart=true
                            
                            attack.removeFromParent()
                            shoot.removeFromParent()
                            sword.removeFromParent()
                            analogJoystick.stick.position.x=0.0
                            analogJoystick.stick.position.y=0.0
                            
                            jump.removeFromParent()
                        }
                    }
                }
            }
        }
        for rat in rats{
            if(rat.frame.intersects(player!.frame)){
                attackEnemy(enemy: rat)
                
                rat.playercontact=true
            }else{
                rat.playercontact=false
            }
            if(abs(player!.position.x-rat.position.x)<=200&&abs(player!.position.y-rat.position.y)<=200){
                attackEnemySword(enemy: rat)
            }
            
            
            rat.update()
            
            for r in rat.physicsBody!.allContactedBodies(){
                
                if r.categoryBitMask==PhysicsCategory.player{
                    
                    // bat.position.x+=2*bat.sp
                    if (hp>0&&ratCanAttack==true){
                        hp -= 1
                        hitmarker(place:player!.position)
                        ratCanAttack = false
//                        print("yes")
                        health.text="x"+String(hp)
                        defaul.setValue(hp, forKey: "hp")
                        if hp==0{
                            
                            
                            
                            endGameTimerStart=true
                            
                            attack.removeFromParent()
                            shoot.removeFromParent()
                            sword.removeFromParent()
                            analogJoystick.stick.position.x=0.0
                            analogJoystick.stick.position.y=0.0
                            
                            jump.removeFromParent()
                        }
                    }
                }
            }
        }
//        for b in bats{
////            b.update()
//            if(abs(player!.position.x-b.position.x)<=200&&abs(player!.position.y-b.position.y)<=200){
//                //            print("hi")
//                if ((((player?.position.x)!<=b.position.x)&&(b.xScale == -1))||(((player?.position.x)!>=b.position.x)&&(b.xScale==1))){
//                    if (hp>0){
//                        hp -= 1
//                        health.text="x"+String(hp)
//                        defaul.setValue(hp, forKey: "hp")
//                        if hp==0{
//                            endGameTimerStart=true
//                            attack.removeFromParent()
//                            sword.removeFromParent()
//                            shoot.removeFromParent()
//                            analogJoystick.removeFromParent()
//                            jump.removeFromParent()
//                        }
//                        //                        b.atk=false
//                    }
//                }
//                attackEnemy(enemy: b)
//            }
//            if(abs(player!.position.x-b.position.x)<=200&&abs(player!.position.y-b.position.y)<=200){
//                //print("true")
//                //print("hi")
//                if ((((player?.position.x)!<=b.position.x)&&(b.xScale == -1))||(((player?.position.x)!>=b.position.x)&&(b.xScale==1))){
//                    if (hp>0){
//                        hp -= 1
//                        health.text="x"+String(hp)
//                        defaul.setValue(hp, forKey: "hp")
//                        if hp==0{
//                            endGameTimerStart=true
//                            attack.removeFromParent()
//                            shoot.removeFromParent()
//                            analogJoystick.removeFromParent()
//                            jump.removeFromParent()
//                        }
//                        //                        sk.atk=false
//                    }
//                }
//                attackEnemySword(enemy: b)
//            }
//        }
        for sk in skeletons{
            sk.update()
//            for b in sk.physicsBody!.allContactedBodies(){h=
//
//                if b.categoryBitMask==PhysicsCategory.skeleton{
//
//                    sk.sp = -1*sk.sp
//                    sk.xScale = -1*sk.xScale
//                   
//
//                }
//            }
            if(abs(player!.position.x-sk.position.x)<=200&&abs(player!.position.y-sk.position.y)<=200){
                //            print("hi")
                if ((((player?.position.x)!<=sk.position.x)&&(sk.xScale == -1))||(((player?.position.x)!>=sk.position.x)&&(sk.xScale==1))){
                    if (hp>0&&sk.atk==true){
                        hp -= 1
                        hitmarker(place: player!.position)
                        health.text="x"+String(hp)
                        defaul.setValue(hp, forKey: "hp")
                        if hp==0{
                            endGameTimerStart=true
                            attack.removeFromParent()
                            sword.removeFromParent()
                            shoot.removeFromParent()
                            analogJoystick.stick.position.x=0.0
                            analogJoystick.stick.position.y=0.0
                            
                            jump.removeFromParent()
                        }
                        sk.atk=false
                    }
                }
                if(player!.frame.intersects(sk.frame)){
                    
                attackEnemy(enemy: sk)
                }
            }
            if(abs(player!.position.x-sk.position.x)<=200&&abs(player!.position.y-sk.position.y)<=200){
                //print("true")
                //print("hi")
                if ((((player?.position.x)!<=sk.position.x)&&(sk.xScale == -1))||(((player?.position.x)!>=sk.position.x)&&(sk.xScale==1))){
                    if (hp>0&&sk.atk==true){
                        hp -= 1
                        hitmarker(place: player!.position)
                        health.text="x"+String(hp)
                        defaul.setValue(hp, forKey: "hp")
                        if hp==0{
                            endGameTimerStart=true
                       
                            attack.removeFromParent()
                            shoot.removeFromParent()
                            sword.removeFromParent()
                            analogJoystick.stick.position.x=0.0
                            analogJoystick.stick.position.y=0.0
                           
                            jump.removeFromParent()
                        }
                        sk.atk=false
                    }
                }
                attackEnemySword(enemy: sk)
            }
        }
        if(player!.frame.intersects(firstboss!.frame)){
            if((((player?.position.x)!<=firstboss!.position.x)&&(firstboss!.xScale == -1))||(((player?.position.x)!>=firstboss!.position.x)&&(firstboss!.xScale==1))){
                if(hp>0&&(firstboss!.isattack2||firstboss!.isattack1)){
                    hp-=1
                    hitmarker(place: player!.position)
                    health.text="x"+String(hp)
                    firstboss!.isattack1 = false
                    firstboss!.isattack2 = false
                }
                if hp==0{
                    endGameTimerStart=true
               
                    attack.removeFromParent()
                    shoot.removeFromParent()
                    sword.removeFromParent()
                    analogJoystick.stick.position.x=0.0
                    analogJoystick.stick.position.y=0.0
                 
                    jump.removeFromParent()
                    
                    
                    
                    
                  
                    
                }
            }
            attackBoss(enemy: firstboss!)
        }
        if(abs(player!.position.x-firstboss!.position.x)<=200&&abs(player!.position.y-firstboss!.position.y)<=200){
            if((((player?.position.x)!<=firstboss!.position.x)&&(firstboss!.xScale == -1))||(((player?.position.x)!>=firstboss!.position.x)&&(firstboss!.xScale==1))){
                if(hp>0&&(firstboss!.isattack2||firstboss!.isattack1)){
                    hp-=1
                    hitmarker(place: player!.position)
                    health.text="x"+String(hp)
                    firstboss!.isattack1 = false
                    firstboss!.isattack2 = false
                }
            }
            attackBossSword(enemy: firstboss!)
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
        if endGameTimerStart{
            endgameTimer+=1
        }
        if (endgameTimer==50){
            
            analogJoystick.removeFromParent()
            isAttacking = false
            isAttacking2 = false
            atk=false
            atk2 = false
            turnedLeft = false
            turnedRight = false
            
            if let view = self.view {
                // Load the SKScene from 'GameScene.sks'
                //reset maps:
                if let scene = SKScene(fileNamed: "Menu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFit
                    
                    // Present the scene
                    view.presentScene(scene)
                }
                view.showsPhysics = false
                view.ignoresSiblingOrder = true
                
                view.showsFPS = false
                view.showsNodeCount = false //hi
            }
        }
        if(carlos != nil){
                 if(player!.frame.intersects(carlos!.frame)==true&&gunEnable==false){
                   //  print("hello")
                     gunEnable = true
                     defaul.set(true, forKey: "gunEnable")
                     self.addChild(gun!)
                     cam.addChild(shoot)
                 }
             }
        if(steve != nil){
            if(player!.frame.intersects(steve!.frame)==true&&swordEnable==false){
                swordEnable = true
                defaul.set(true, forKey: "swordEnable")
                cam.addChild(sword)
            }
        }
        if (door != nil){
            var allow = true
            for bat in bats {
                if(bat.parent != nil){
                    allow=false
                }
            }
            for sk in skeletons {
                if(sk.parent != nil){
                    allow = false
                }
            }
            for rat in rats{
                if(rat.parent != nil){
                    allow = false
                }
            }
            if(player!.frame.intersects(door!.frame)==true&&allow==true){
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
                        
                        view.showsFPS = false
                        view.showsNodeCount = false //hi
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
                        
                        view.showsFPS = false
                        view.showsNodeCount = false //hi
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
