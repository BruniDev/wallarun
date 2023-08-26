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
    
    let wallabyCategory = 1 << 0 as UInt32
    let groundCategory = 1 << 1 as UInt32
    let rockCategory = 1 << 2 as UInt32
    
    override func didMove(to view: SKView) {
        let backgroundSound = SKAudioNode(fileNamed: "Background.mp3")
        self.addChild(backgroundSound)
        self.backgroundColor = .white
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -15)
        self.physicsWorld.contactDelegate = self
        
        createWallaby(for: self.size)
        
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
        spawnRocks()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isJumping {
            isJumping = true
            wallaby.texture = SKTexture(imageNamed: "WallabyJump")
            wallaby.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
        }
    }
    
    func createWallaby(for size: CGSize) {
        wallaby = SKSpriteNode(imageNamed: "WallabyDown")
        wallaby.size = CGSize(width: 57.5, height: 58.75)
        wallaby.position = CGPoint(x: 150, y: self.size.height/2)
        wallaby.zPosition = 1
        
        wallaby.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "WallabyDown"), size: wallaby.size)
        wallaby.physicsBody?.isDynamic = true
        wallaby.physicsBody?.allowsRotation = false
        wallaby.physicsBody?.restitution = 0.0
        
        wallaby.physicsBody?.categoryBitMask = wallabyCategory
        wallaby.physicsBody?.contactTestBitMask = groundCategory | rockCategory
        wallaby.physicsBody?.collisionBitMask = groundCategory
        
        self.addChild(wallaby)
    }
    
    func walkWallaby() {
        if !isJumping {
            let jumpAction = SKAction.run {
                self.wallaby.texture = SKTexture(imageNamed: "WallabyUp")
                self.wallaby.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
            }
            let delay = SKAction.wait(forDuration: 0.4)
            let jumpSequence = SKAction.sequence([jumpAction, delay])
            let repeatJump = SKAction.repeatForever(jumpSequence)
            wallaby.run(repeatJump)
        }
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
            
            ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1024, height: 90))
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.restitution = 0.0
            
            ground.physicsBody?.categoryBitMask = groundCategory
            ground.physicsBody?.contactTestBitMask = wallabyCategory
            ground.physicsBody?.collisionBitMask = wallabyCategory
            
            ground.run(moveForever)
            self.addChild(ground)
        }
    }
    
    func createRockAndMove() {
        let rockTextures = ["RockL", "RockM"]
        let randomRock = rockTextures.randomElement()!
        
        rock = SKSpriteNode(imageNamed: randomRock)
        rock.size = randomRock == "RockL" ? CGSize(width: 62.5, height: 62.5) : CGSize(width: 45, height: 62.5)
        rock.position = CGPoint(x: self.size.width, y: 105)
        
        rock.physicsBody = SKPhysicsBody(texture: rock.texture!, size: rock.size)
        rock.physicsBody?.isDynamic = false
        
        rock.physicsBody?.categoryBitMask = rockCategory
        rock.physicsBody?.contactTestBitMask = wallabyCategory
        rock.physicsBody?.collisionBitMask = 0
        
        let moveLeft = SKAction.moveBy(x: -self.size.width - rock.size.width, y: 0, duration: 3.6)
        let remove = SKAction.removeFromParent()
        let moveSequence = SKAction.sequence([moveLeft, remove])
        
        rock.run(moveSequence)
        self.addChild(rock)
    }
    
    func spawnRocks() {
        let spawnRocks = SKAction.run(createRockAndMove)
        let delay = SKAction.wait(forDuration: 2, withRange: 2)
        let spawnSequence = SKAction.sequence([spawnRocks, delay])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever)
    }
    
    func blinkWallaby() {
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        let blinkRepeat = SKAction.repeat(blink, count: 3)
        
        wallaby.run(blinkRepeat)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.node == wallaby || bodyB.node == wallaby {
            wallaby.texture = SKTexture(imageNamed: "WallabyDown")
            isJumping = false
        }
        
        let wallabyBody: SKPhysicsBody
        let otherBody: SKPhysicsBody
        
        if bodyA.node == wallaby {
            wallabyBody = bodyA
            otherBody = bodyB
        } else if bodyB.node == wallaby {
            wallabyBody = bodyB
            otherBody = bodyA
        } else {
            return
        }
        
        if wallabyBody.categoryBitMask == rockCategory || otherBody.categoryBitMask == rockCategory {
            blinkWallaby()
        }
    }
}
