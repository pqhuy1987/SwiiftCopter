//
//  GameOverScene.swift
//  SwiftCopters
//
//  Created by MARIO EGUILUZ ALEBICTO on 01/09/14.
//  Copyright (c) 2014 MARIO EGUILUZ ALEBICTO. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var viewController:GameViewController?
    
    //Init
    override func didMove(to view: SKView) {
        
        let nodeLabel = SKLabelNode(fontNamed: "Lobster 1.4")
        nodeLabel.text = "game over"
        nodeLabel.fontSize = 50
        nodeLabel.fontColor = SKColor.white
        nodeLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/3*2)
        nodeLabel.alpha = 0.0
        nodeLabel.run(SKAction.fadeAlpha(to: 1.0, duration: 1.0))
        self.addChild(nodeLabel)
        
        let spriteFace = SKSpriteNode(imageNamed: "booGameOver")
        spriteFace.size = CGSize(width: spriteFace.size.width/2, height: spriteFace.size.height/2)
        spriteFace.position = CGPoint(x: self.frame.width/2, y: -spriteFace.size.height/2)
        spriteFace.run(SKAction.moveTo(y: spriteFace.size.height/2, duration: 0.7))
        self.addChild(spriteFace)
        
        self.backgroundColor = SKColor(red: 20/255, green: 129/255, blue: 197/255, alpha: 1.0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewController?.presentGameScene()
    }
}
