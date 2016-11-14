//
//  GameViewController.swift
//  SwiftCopters
//
//  Created by MARIO EGUILUZ ALEBICTO on 31/08/14.
//  Copyright (c) 2014 MARIO EGUILUZ ALEBICTO. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchive(from file : String) -> SKNode?  {
        if let url = Bundle.main.url(forResource: file as String, withExtension: "sks") {
            do {
                let sceneData = try Data(contentsOf: url)
                let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
                
                archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
                
                if file == "GameScene"{
                    let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
                    archiver.finishDecoding()
                    return scene
                }
                else {
                    let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameOverScene
                    archiver.finishDecoding()
                    return scene
                }
            }
            catch {
                return nil
            }
            
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presentGameScene()
    }

    func presentGameScene() {
        if let scene = GameScene.unarchive(from: "GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            //skView.showsPhysics = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .resizeFill

            //reference to self
            scene.viewController = self
            
            skView.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.5))
        }
    }

    func presentGameOverScene() {
        if let scene = GameOverScene.unarchive(from: "GameOverScene") as? GameOverScene {
            // Configure the view.
            let skView = self.view as! SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            //skView.showsPhysics = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .resizeFill

            //reference to self
            scene.viewController = self
            
            skView.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.5))
        }
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask(rawValue: UInt(Int(UIInterfaceOrientationMask.allButUpsideDown.rawValue)))
        } else {
            return UIInterfaceOrientationMask(rawValue: UInt(Int(UIInterfaceOrientationMask.all.rawValue)))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
