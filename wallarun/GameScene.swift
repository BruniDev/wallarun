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
    private var rock: SKSpriteNode!
    private var isJumping: Bool = false
    
    override func didMove(to view: SKView) {
        let backgroundSound = SKAudioNode(fileNamed: "Background.mp3")
        self.addChild(backgroundSound)
        self.backgroundColor = .white
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        self.physicsWorld.contactDelegate = self
        
        createWallaby(for: self.size)
        
        

        createGroundAndMove(for: self.size)
        createBackgroundAndMove(for: self.size)
        walkWallaby()
        spawnRocks()
        
        // Progress bar
        progressBar.getSceneFrame(sceneFrame: frame)
        progressBar.buildProgressBar(for: self.size)
        addChild(progressBar)
        
        var count = 0
        
        // Call updateProgressBar() and count++ per every second
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if count > 60 { timer.invalidate() }
            
            self.progressBar.updateProgressBar()
            
            count += 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isJumping {
            isJumping = true
            wallaby.texture = SKTexture(imageNamed: "WallabyJump")
            wallaby.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 35))
        }
    }
    
    func createWallaby(for size: CGSize) {
        wallaby = SKSpriteNode(imageNamed: "WallabyDown")
        wallaby.size = CGSize(width: 57.5, height: 58.75)
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
            self.wallaby.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
        }
        let delay = SKAction.wait(forDuration: 0.4)
        let jumpSequence = SKAction.sequence([jumpAction, delay])
        let repeatJump = SKAction.repeatForever(jumpSequence)
        wallaby.run(repeatJump)
    }
    
    func createBackgroundAndMove(for size: CGSize) {
        let backgroundSize = CGSize(width: 1024, height: 416.5)
        let moveLeft = SKAction.moveBy(x: -backgroundSize.width, y: 0, duration: 16.0)
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
        let groundSize = CGSize(width: 1024, height: 105)
        let moveLeft = SKAction.moveBy(x: -groundSize.width, y: 0, duration: 4.0)
        let resetPosition = SKAction.moveBy(x: groundSize.width, y: 0, duration: 0)
        let moveSequence = SKAction.sequence([moveLeft, resetPosition])
        let moveForever = SKAction.repeatForever(moveSequence)
        
        for i in 0..<3 {
            ground = SKSpriteNode(imageNamed: "BackGroundImage_Bottom")
            ground.size = groundSize
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: 40)
            
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
    
    func createRockAndMove() {
        let rockTextures = ["RockL", "RockM"]
        
        rock = SKSpriteNode(imageNamed: rockTextures.randomElement() ?? "RockL")
        rock.size = CGSize(width: 62.5, height: 62.5)
        rock.position = CGPoint(x: self.size.width, y: 110)
        
        rock.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "RockL"), size: rock.size)
        rock.physicsBody?.isDynamic = false
        
        rock.physicsBody?.categoryBitMask = 3
        rock.physicsBody?.contactTestBitMask = 1
        rock.physicsBody?.collisionBitMask = 1
        
        let moveLeft = SKAction.moveBy(x: -self.size.width - rock.size.width, y: 0, duration: 3.6)
        let remove = SKAction.removeFromParent()
        let moveSequence = SKAction.sequence([moveLeft, remove])
        
        rock.run(moveSequence)
        self.addChild(rock)
    }
    
    func spawnRocks() {
        let spawnRocks = SKAction.run(createRockAndMove)
        let delay = SKAction.wait(forDuration: 3, withRange: 3)
        let spawnSequence = SKAction.sequence([spawnRocks, delay])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever)
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
