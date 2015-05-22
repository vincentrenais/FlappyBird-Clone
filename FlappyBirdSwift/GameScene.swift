//
//  GameScene.swift
//  FlappyBirdSwift
//
//  Created by Vincent Renais on 2015-05-20.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0
    var scoreLabel = SKLabelNode()
    var bird = SKSpriteNode()
    var background = SKSpriteNode()
    var background1 = SKSpriteNode()
    var movingObjects = SKNode()
    let birdGroup:UInt32 = 1 << 0
    let worldGroup:UInt32 = 1 << 1
    let gapGroup:UInt32 = 1 << 2
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.addChild(movingObjects)
        self.playSound("music/music.mp3", shouldRepeat: true)
        
        
        
        // BACKGROUND
        
        var backgroundTexture = SKTexture(imageNamed: "img/Ocean2.png")
        var moveBackground = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: 9)
        var replaceBackground = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0)
        var moveBackgroundForever = SKAction.repeatActionForever(SKAction.sequence([moveBackground, replaceBackground]))
        for var i:CGFloat = 0; i < 3; i++ {
            background1 = SKSpriteNode(texture: backgroundTexture)
            background1.position = CGPoint(x: backgroundTexture.size().width/2 + backgroundTexture.size().width * i, y: CGRectGetMidY(self.frame))
            background1.size.height = self.frame.height
            background1.runAction(moveBackgroundForever)
            movingObjects.addChild(background1)
        }
        
        var backgroundTexture1 = SKTexture(imageNamed: "img/Ocean1_FG.png")
        var moveBackground1 = SKAction.moveByX(-backgroundTexture1.size().width, y: 0, duration: 15)
        var replaceBackground1 = SKAction.moveByX(backgroundTexture1.size().width, y: 0, duration: 0)
        var moveBackgroundForever1 = SKAction.repeatActionForever(SKAction.sequence([moveBackground1, replaceBackground1]))
        for var i:CGFloat = 0; i < 3; i++ {
            background = SKSpriteNode(texture: backgroundTexture1)
            background.position = CGPoint(x: backgroundTexture1.size().width/2 + backgroundTexture1.size().width * i, y: CGRectGetMidY(self.frame))
            background.size.height = self.frame.height
            background.runAction(moveBackgroundForever1)
            movingObjects.addChild(background)
        }
        
        // SCORE LABEL
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        
        // BIRD
        
        var birdTexture1 = SKTexture(imageNamed: "img/flappy1.png")
        var birdTexture2 = SKTexture(imageNamed: "img/flappy2.png")
        var animation = SKAction.animateWithTextures([birdTexture1, birdTexture2], timePerFrame: 0.1)
        var makeBirdFlap = SKAction.repeatActionForever(animation)
        bird = SKSpriteNode(texture: birdTexture1)
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.runAction(makeBirdFlap)
        bird.setScale(0.6)
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.categoryBitMask = birdGroup
        bird.physicsBody?.collisionBitMask = worldGroup
        bird.physicsBody?.contactTestBitMask = gapGroup | worldGroup;
        bird.zPosition = 10
        self.addChild(bird)
        
        
        // GROUND
        
        var ground = SKNode()
        ground.position = CGPointMake(0,0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false;
        ground.physicsBody?.categoryBitMask = worldGroup
        self.addChild(ground)
        
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
    }
    
    // FUNCTION TO MAKE PIPES
    
    func makePipes() {
        
        
        let gapHeight = bird.size.height * 8 // Gap between the pipes
        
        var movementAmount = arc4random() % UInt32(self.frame.size.height/1.5) // Create a movement var to get a random value
        var pipeOffSet = CGFloat(movementAmount) - self.frame.size.height / 4 // Use that movement to create a an offset value
        var movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width / 50))
        var removePipes = SKAction.removeFromParent()
//        var moveAndRemove = SKAction.sequence([movePipes, removePipes])
        var moveAndRemove = SKAction.repeatActionForever(SKAction.sequence([movePipes, removePipes]))
        
        
        
        // PIPE 1
        
        var pipeTexture1 = SKTexture(imageNamed: "img/pipe1.png")
        var pipe1 = SKSpriteNode(texture: pipeTexture1)
        pipe1.runAction(moveAndRemove)
        pipe1.setScale(0.6)
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipe1.size)
        pipe1.physicsBody?.dynamic = false
        pipe1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipe1.size.height/2 + gapHeight/2 + pipeOffSet)
        pipe1.physicsBody?.categoryBitMask = worldGroup
        movingObjects.addChild(pipe1)
        
        
        
        // PIPE 2
        
        var pipeTexture2 = SKTexture(imageNamed: "img/pipe2.png")
        var pipe2 = SKSpriteNode(texture: pipeTexture2)
        pipe2.runAction(moveAndRemove)
        pipe2.setScale(0.6)
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2.size)
        pipe2.physicsBody?.dynamic = false
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipe2.size.height/2 - gapHeight/2 + pipeOffSet)
        pipe2.physicsBody?.categoryBitMask = worldGroup
        movingObjects.addChild(pipe2)
        
        
        
        // GAP
        
        var gap = SKNode()
        gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeOffSet)
        gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width, gapHeight))
        gap.runAction(moveAndRemove)
        gap.physicsBody?.dynamic = false
        gap.physicsBody?.categoryBitMask = gapGroup
        gap.physicsBody?.contactTestBitMask = birdGroup
        gap.physicsBody?.collisionBitMask = 0;
        movingObjects.addChild(gap)

    }


    func didBeginContact(contact: SKPhysicsContact)
    {
        if contact.bodyB.categoryBitMask == gapGroup || contact.bodyA.categoryBitMask == gapGroup
        {
            score++
            scoreLabel.text = "\(score)"
            
        } else
        {
            movingObjects.speed = 0
            var scene = GameOverScene(size: self.size)
            let skView = self.view as SKView?
            skView?.ignoresSiblingOrder = true
            scene.scaleMode = .AspectFill
            scene.size = skView!.bounds.size
            skView?.presentScene(scene)
        }
    }
    
    func playSound(audio:String, shouldRepeat:Bool)
    {
        var sound = SKAction.playSoundFileNamed(audio, waitForCompletion: shouldRepeat)
        runAction(sound)
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent){
        /* Called when a touch begins */
    
        bird.physicsBody?.velocity = CGVectorMake(0, 0)
        bird.physicsBody?.applyImpulse(CGVectorMake(0, 20))
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}