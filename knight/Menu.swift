//
//  Menu.swift
//  knight
//
//  Created by 64004018 on 2/23/22.
//

//
//  Menu.swift
//  knight
//
//  Created by 64004018 on 2/23/22.
//

import UIKit
import SpriteKit
import GameplayKit
import Foundation
import AudioToolbox
var startLabel: SKLabelNode?



class Menu: SKScene {
    override func didMove(to view: SKView){
        startLabel = self.childNode(withName: "startLabel") as?SKLabelNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            if ((startLabel?.contains(pointOfTouch)) != nil){
                if let view = self.view {
                    // Load the SKScene from 'GameScene.sks'
                    //reset maps:
//                    defaul.setValue(nil, forKey: "scene")
                    
                    if (defaul.string(forKey: "scene") == nil){
                        defaul.setValue("GameScene", forKey: "scene")
                    }
                    if let scene = SKScene(fileNamed: defaul.string(forKey: "scene")!) {
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
}
