//
//  GameViewController.swift
//  FastShooterGame
//
//  Created by 64011731 on 2/22/21.
//

import UIKit
import SpriteKit
import GameplayKit



class GameViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
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
            view.isMultipleTouchEnabled = true
        }

    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscapeRight
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

