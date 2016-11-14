//
//  GameScene.swift
//  SwiftCopters
//
//  Created by MARIO EGUILUZ ALEBICTO on 31/08/14.
//  Copyright (c) 2014 MARIO EGUILUZ ALEBICTO. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var viewController:GameViewController?
    
    //Game Variables
    var colorBackground:SKColor! = SKColor(red: 20/255, green: 129/255, blue: 197/255, alpha: 1.0)
    var start:Bool = false
    
    let categoryCopter:UInt32   = 0x1 << 0
    let categoryEnemy:UInt32    = 0x1 << 1
    let categoryScreen:UInt32   = 0x1 << 2
    
    let linearDamping:CGFloat = 0.65
    let angularDamping:CGFloat = 1.0
    var gravityX:CGFloat = 6
    let impulseY:CGFloat = 4.0
    let impulseX:CGFloat = 10.0
    var lastYposition:CGFloat = 300.0
    let ditanceBetweenBars:CGFloat = 175.0
    let ditanceFromBarToBar:CGFloat = 300.0
    
    //Nodes
    //SKSCENE
    let nodePoints = SKLabelNode()
    let nodeClouds = SKNode()
    let nodeWorld = SKNode()
    let nodeEnemies = SKNode()
    var nodeCopter = SKNode()
    var spriteCopter:SKSpriteNode!
    
    //Init
    override func didMove(to view: SKView) {
        
        self.startWorld()
        self.initPhysics()
        self.startGround()
        self.startCopter()
        self.startClouds()
        self.startEnemies()
        nodeWorld.addChild(nodeEnemies)
    }
    
    func initPhysics() {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: gravityX, dy: 0.0)
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.categoryBitMask = categoryScreen
        nodeWorld.physicsBody = borderBody
    }
    
    func startWorld() {
        self.backgroundColor = colorBackground
        self.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        self.addChild(nodeWorld)
        
        nodePoints.fontName = "Lobster 1.4"
        nodePoints.text = "0123456789"
        nodePoints.text = "0"
        nodePoints.fontSize = 48
        nodePoints.fontColor = SKColor.white
        nodePoints.position = CGPoint(x: 0, y: self.frame.size.height*0.33)
        nodePoints.zPosition = 100;
        self.addChild(nodePoints)
    }
    
    
    func startGround() {
        let spriteGround = SKSpriteNode(imageNamed: "footer")
        spriteGround.zPosition = 1
        spriteGround.size = CGSize(width: spriteGround.size.width/2, height: spriteGround.size.height/2)
        spriteGround.position = CGPoint(x: 0, y: -27)
        nodeWorld.addChild(spriteGround)
    }
    
    //Create copter
    func startCopter() {
        nodeCopter.position = CGPoint(x: 0,y: 0)
        nodeCopter.zPosition = 10
        
        spriteCopter = SKSpriteNode(imageNamed: "booCopter1")
        spriteCopter.size = CGSize(width: spriteCopter.size.width/3, height: spriteCopter.size.height/3)
        spriteCopter.position = CGPoint(x: 0,y: 0)
        
        nodeCopter.addChild(spriteCopter)
        nodeWorld.addChild(nodeCopter)
        
        let nodeBody = SKPhysicsBody(circleOfRadius: 0.9*spriteCopter.frame.size.width/2)
        nodeBody.linearDamping = linearDamping
        nodeBody.angularDamping = angularDamping
        nodeBody.allowsRotation = true
        nodeBody.affectedByGravity = false
        nodeBody.categoryBitMask = categoryCopter;
        nodeBody.contactTestBitMask = categoryScreen | categoryEnemy;
        nodeCopter.physicsBody = nodeBody;
        
    }
    
    //Create clouds
    func startClouds() {
        nodeClouds.position = CGPoint(x: -self.size.width/2,y: -self.size.height/2);
        self.addChild(nodeClouds)
        
        let cloud = SKSpriteNode(imageNamed: "cloud")
        cloud.size = CGSize(width:cloud.size.width/2, height:cloud.size.height/2)
        cloud.position = CGPoint(x: 220, y: cloud.size.height/2)
        nodeClouds.addChild(cloud)
        cloud.run(SKAction.repeatForever(SKAction.moveBy(x: 0, y: -self.size.height-cloud.size.height, duration: 5 )))
        
        let cloud2 = SKSpriteNode(imageNamed: "cloud")
        cloud2.size = CGSize(width:cloud2.size.width/2, height:cloud2.size.height/2)
        cloud2.position = CGPoint(x: 95, y: cloud.size.height/2+160)
        nodeClouds.addChild(cloud2)
        cloud2.run(SKAction.repeatForever(SKAction.moveBy(x: 0, y: -self.size.height-cloud.size.height, duration: 5 )))
        
        let cloud3 = SKSpriteNode(imageNamed: "cloud")
        cloud3.size = CGSize(width:cloud3.size.width/2, height:cloud3.size.height/2)
        cloud3.position = CGPoint(x: 220, y: cloud.size.height/2+160*2)
        nodeClouds.addChild(cloud3)
        cloud3.run(SKAction.repeatForever(SKAction.moveBy(x: 0, y: -self.size.height-cloud.size.height, duration: 5 )))
        
        let cloud4 = SKSpriteNode(imageNamed: "cloud")
        cloud4.size = CGSize(width:cloud4.size.width/2, height:cloud4.size.height/2)
        cloud4.position = CGPoint(x: 95, y: cloud.size.height/2+160*3)
        nodeClouds.addChild(cloud4)
        cloud4.run(SKAction.repeatForever(SKAction.moveBy(x: 0, y: -self.size.height-cloud.size.height, duration: 5 )))
    }
    
    func startEnemies(){
        
        for _ in 1...10 {
            //1
            let randomX:CGFloat = -(CGFloat(Int(arc4random_uniform(160)))+160) //-320 to -160  ---  -160 to 0
            
            //2
            let nodeEnemy = SKNode()
            
            //3
            //BARS
            let spriteBarLeft = SKSpriteNode(imageNamed:"enemyBarLeft")
            spriteBarLeft.size = CGSize(width: spriteBarLeft.size.width/2, height: spriteBarLeft.size.height/2)
            spriteBarLeft.position = CGPoint(x: randomX,y: 0)
            spriteBarLeft.zPosition = 5;
            let borderBody:SKPhysicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: spriteBarLeft.size.width, height: spriteBarLeft.size.height))
            borderBody.isDynamic = false;
            borderBody.categoryBitMask = categoryEnemy;
            borderBody.affectedByGravity = false;
            spriteBarLeft.name = "enemyBarLeft";
            spriteBarLeft.anchorPoint = CGPoint(x: 0, y: 0)
            spriteBarLeft.physicsBody = borderBody;
            nodeEnemy.addChild(spriteBarLeft)
            
            let spriteBarRight = SKSpriteNode(imageNamed:"enemyBarRight")
            spriteBarRight.size = CGSize(width: spriteBarRight.size.width/2, height: spriteBarRight.size.height/2)
            spriteBarRight.position = CGPoint(x: spriteBarLeft.position.x + spriteBarLeft.size.width + ditanceBetweenBars,y: 0)
            spriteBarRight.zPosition = 5;
            let borderBodyRight:SKPhysicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: spriteBarRight.size.width, height: spriteBarRight.size.height))
            borderBodyRight.isDynamic = false;
            borderBodyRight.categoryBitMask = categoryEnemy
            borderBodyRight.affectedByGravity = false;
            spriteBarRight.name = "enemyBarRight";
            spriteBarRight.anchorPoint = CGPoint(x: 0, y: 0)
            spriteBarRight.physicsBody = borderBodyRight
            
            //4
            //HAMMERS
            let spriteSwingLeft = SKSpriteNode(imageNamed: "enemySwing")
            spriteSwingLeft.size = CGSize(width: spriteSwingLeft.size.width/2, height: spriteSwingLeft.size.height/2)
            spriteSwingLeft.zPosition = 4
            spriteSwingLeft.anchorPoint = CGPoint(x: 0.5, y: 1)
            spriteSwingLeft.position = CGPoint(x: randomX+141,y: 9)
            spriteSwingLeft.zRotation = -3.14/8
            
            let spriteSwingRight = SKSpriteNode(imageNamed: "enemySwing")
            spriteSwingRight.size = CGSize(width: spriteSwingRight.size.width/2, height: spriteSwingRight.size.height/2)
            spriteSwingRight.zPosition = 4
            spriteSwingRight.anchorPoint = CGPoint(x: 0.5, y: 1)
            spriteSwingRight.position = CGPoint(x: randomX+141+ditanceBetweenBars+37 ,y: 9)
            spriteSwingRight.zRotation = -3.14/8
            
            let borderBodySwings = SKPhysicsBody(edgeLoopFrom: CGRect(x: -spriteSwingLeft.size.width/2, y: -spriteSwingLeft.size.height, width: spriteSwingLeft.size.width*0.9, height: 0.4*spriteSwingLeft.size.height))
            borderBodySwings.isDynamic = false
            borderBodySwings.categoryBitMask = categoryEnemy
            borderBodySwings.affectedByGravity = false
            spriteSwingLeft.name = "enemySwing"
            spriteSwingLeft.physicsBody = borderBodySwings
            
            let borderBodySwingsRight = SKPhysicsBody(edgeLoopFrom: CGRect(x: -spriteSwingRight.size.width/2, y: -spriteSwingRight.size.height, width: spriteSwingRight.size.width*0.9, height: 0.4*spriteSwingRight.size.height))
            borderBodySwingsRight.isDynamic = false
            borderBodySwingsRight.categoryBitMask = categoryEnemy
            borderBodySwingsRight.affectedByGravity = false
            spriteSwingRight.name = "enemySwing"
            spriteSwingRight.physicsBody = borderBodySwingsRight
            
            //5
            let actionSwing:SKAction = SKAction.sequence([SKAction.rotate(byAngle: 3.14/4, duration: 1),SKAction.rotate(byAngle: -3.14/4, duration: 1)])
            spriteSwingLeft.run(SKAction.repeatForever(actionSwing))
            spriteSwingRight.run(SKAction.repeatForever(actionSwing))
            
            //6
            //Final set up
            nodeEnemy.addChild(spriteSwingLeft)
            nodeEnemy.addChild(spriteSwingRight)
            
            nodeEnemy.position = CGPoint(x: 0, y: lastYposition)
            nodeEnemy.addChild(spriteBarRight)
            
            nodeEnemies.addChild(nodeEnemy)
            
            //7
            lastYposition += ditanceFromBarToBar
        }
    }
    
    //game loop
    override func didSimulatePhysics() {
        self.shouldRepositeNodes()
        self.centerOnNode(nodeCopter)
        self.updatePoints()
    }
    
    //Here we reposition out of the screen clouds/enemies to the top of the sky again
    func shouldRepositeNodes() {
        let arrayClouds:Array<SKSpriteNode> = nodeClouds.children as! Array<SKSpriteNode>
        for spriteCloud:SKSpriteNode in arrayClouds {
            if spriteCloud.position.y < -spriteCloud.size.height/2 {
                spriteCloud.position.y = -spriteCloud.size.height/2 + 160*4
            }
        }
        
        let arrayEnemies:Array<SKNode> = nodeEnemies.children as Array<SKNode>
        for nodeEnemy:SKNode in arrayEnemies {
            if nodeEnemy.position.y - nodeCopter.position.y < -300.0 {
                nodeEnemy.position.y = lastYposition + ditanceFromBarToBar;
                lastYposition += ditanceFromBarToBar;
            }
        }
    }
    
    //To mantain the copter in the centered at the bottom of the screen
    func centerOnNode(_ node:SKNode) {
        let cameraPositionInScene = node.scene?.convert(node.position, from: node.parent!)
        
        node.parent?.position = CGPoint(x: node.parent!.position.x, y: node.parent!.position.y - cameraPositionInScene!.y-self.frame.size.height/3);
    }
    
    
    func updatePoints() {
        nodePoints.text = "\(Int(nodeCopter.position.y/300))"
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !start {
            nodeCopter.physicsBody?.affectedByGravity = true
            spriteCopter.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed:"booCopter1"),SKTexture(imageNamed:"booCopter2"),SKTexture(imageNamed:"booCopter3"),SKTexture(imageNamed:"booCopter4")], timePerFrame: 0.075)))
            nodeCopter.physicsBody?.isDynamic = true
        }
        start = true;
        
        for _: AnyObject in touches {
            if gravityX > 0 {
                gravityX = -4
                self.physicsWorld.gravity = CGVector(dx: gravityX, dy: 0.0)
                self.nodeCopter.physicsBody?.applyImpulse(CGVector(dx: impulseX, dy: impulseY))
                nodeCopter.run(SKAction.rotate(toAngle: +3.14/10, duration: 0.3))//rigth
            }
            else {
                gravityX = 4
                self.physicsWorld.gravity = CGVector(dx: gravityX, dy: 0.0)
                self.nodeCopter.physicsBody?.applyImpulse(CGVector(dx: -impulseX, dy: impulseY))
                nodeCopter.run(SKAction.rotate(toAngle: -3.14/10, duration: 0.3))//left
            }
        }
        
        //We have to change the height of the physics bode to make it larger when the copter goes up
        let borderBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -self.frame.size.width/2, y: -self.frame.size.height/2, width: self.frame.size.width, height: self.frame.size.height+nodeCopter.position.y))
        nodeWorld.physicsBody? = borderBody
        nodeWorld.physicsBody?.categoryBitMask = categoryScreen
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if firstBody.categoryBitMask == categoryCopter && (secondBody.categoryBitMask == categoryEnemy || secondBody.categoryBitMask == categoryScreen) {
            self.resetScene()
        }
    }
    
    func resetScene() {
        viewController?.presentGameOverScene()
    }
}

























