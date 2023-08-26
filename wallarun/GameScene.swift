//
//  GameScene.swift
//  wallarun
//
//  Created by 관식 on 2023/08/25.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // progress vars
    var progressBar = ProgressBar()
    
    private var wallaby: SKSpriteNode!
    private var ground: SKSpriteNode!
    private var background: SKSpriteNode!
    private var isJumping: Bool = false
    
    override func didMove(to view: SKView) {
        let backgroundSound = SKAudioNode(fileNamed: "Background.mp3")
        self.addChild(backgroundSound)
        self.backgroundColor = .white
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -30)
        self.physicsWorld.contactDelegate = self
        createWallaby(for: self.size)
        createGround(for: self.size)
        
        // Progress bar
        progressBar.getSceneFrame(sceneFrame: frame)
        progressBar.buildProgressBar()
        addChild(progressBar)
        
        var count = 0
        
        // Call updateProgressBar() and count++ per every second
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if count > 120 { timer.invalidate() }
            
            self.progressBar.updateProgressBar()
            
            count += 1
        }

        createGroundAndMove(for: self.size)
        createBackgroundAndMove(for: self.size)
        walkWallaby()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isJumping {
            isJumping = true
            wallaby.texture = SKTexture(imageNamed: "WallabyJump")
            wallaby.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
        }
    }
    
    func createWallaby(for size: CGSize) {
        wallaby = SKSpriteNode(imageNamed: "WallabyDown")
        wallaby.size = CGSize(width: 80, height: 81.74)
        wallaby.position = CGPoint(x: 150, y: self.size.height/2)
        
        wallaby.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "WallabyDown"), size: wallaby.size)
        wallaby.physicsBody?.isDynamic = true
        wallaby.physicsBody?.allowsRotation = false
        wallaby.physicsBody?.restitution = 0.0
        
        wallaby.physicsBody?.categoryBitMask = 1
        wallaby.physicsBody?.contactTestBitMask = 2
        wallaby.physicsBody?.collisionBitMask = 2
        
        self.addChild(wallaby)
    }
    
    func walkWallaby() {
        let jumpAction = SKAction.run {
            self.wallaby.texture = SKTexture(imageNamed: "WallabyUp")
            self.wallaby.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
        }
        let delay = SKAction.wait(forDuration: 0.4)
        let jumpSequence = SKAction.sequence([jumpAction, delay])
        let repeatJump = SKAction.repeatForever(jumpSequence)
        wallaby.run(repeatJump)
    }
    
    func createBackgroundAndMove(for size: CGSize) {
        let backgroundSize = CGSize(width: 945.23, height: 246.92)
        let moveLeft = SKAction.moveBy(x: -backgroundSize.width, y: 0, duration: 4.0)
        let resetPosition = SKAction.moveBy(x: backgroundSize.width, y: 0, duration: 0)
        let moveSequence = SKAction.sequence([moveLeft, resetPosition])
        let moveForever = SKAction.repeatForever(moveSequence)
        
        for i in 0..<3 {
            background = SKSpriteNode(imageNamed: "BackGroundImage_Default")
            background.size = backgroundSize
            background.position = CGPoint(x: CGFloat(i) * background.size.width, y: 200)
            background.zPosition = -1
            
            background.run(moveForever)
            self.addChild(background)
        }
    }
    
    func createGroundAndMove(for size: CGSize) {
        let groundSize = CGSize(width: 945.23, height: 60)
        let moveLeft = SKAction.moveBy(x: -groundSize.width, y: 0, duration: 4.0)
        let resetPosition = SKAction.moveBy(x: groundSize.width, y: 0, duration: 0)
        let moveSequence = SKAction.sequence([moveLeft, resetPosition])
        let moveForever = SKAction.repeatForever(moveSequence)
        
        for i in 0..<3 {
            ground = SKSpriteNode(imageNamed: "BackGroundImage_Bottom")
            ground.size = groundSize
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: 20)
            
            ground.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "BackGroundImage_Bottom"), size: ground.size)
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.restitution = 0.0
            
            ground.physicsBody?.categoryBitMask = 2
            ground.physicsBody?.contactTestBitMask = 1
            ground.physicsBody?.collisionBitMask = 1
            
            ground.run(moveForever)
            self.addChild(ground)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.node == wallaby || bodyB.node == wallaby {
            wallaby.texture = SKTexture(imageNamed: "WallabyDown")
            isJumping = false
        }
    }
}
