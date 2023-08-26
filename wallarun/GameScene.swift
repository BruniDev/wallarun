//
//  GameScene.swift
//  wallarun
//
//  Created by 관식 on 2023/08/25.
//

import SwiftUI
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    @Binding var gameState: GameState
    
    init(size: CGSize, gameState: Binding<GameState>) {
        self._gameState = gameState
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // progress vars
    var progressBar = ProgressBar()
    
    // fever time vars
    private var isFeverTime: Bool = false
    private var feverTimeLength: Double = 5.0   // sec
    
    // weed vars
    private var weedCount: Int = 0
    
    // fever time timer vars
    private var feverTimer: Timer?
    
    private var jumpImpulse: Double = 35.0
    
    private var wallaby: SKSpriteNode!
    private var ground: SKSpriteNode!
    private var background: SKSpriteNode!
    private var rock: SKSpriteNode!
    private var weed: SKSpriteNode!
    private var lifeIcon: SKSpriteNode!
    private var lifeGroup = SKSpriteNode()
    private var house: SKSpriteNode!
    private var life = 2
    private var gameTime = 10
    private var isJumping: Bool = false
    private var fevertime : SKVideoNode!
    private var lastPausedTime: TimeInterval?
    let pauseCooldown: TimeInterval = 0.6
    
    private var lastWeedPausedTime: TimeInterval?
    let pauseWeedCooldown: TimeInterval = 0.6
    
    let wallabyCategory = 1 << 0 as UInt32
    let groundCategory = 1 << 1 as UInt32
    let rockCategory = 1 << 2 as UInt32
    let houseCategory = 1 << 3 as UInt32
    let weedCategory = 1 << 4 as UInt32
    
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
        createLives()
        
        // Progress bar
        progressBar.getSceneFrame(sceneFrame: frame)
        progressBar.buildProgressBar(for: self.size)
        addChild(progressBar)
        
        var count = 0
        
        // Call updateProgressBar() and count++ per every second
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if count > self.gameTime {
                self.createHouseAndMove()
                timer.invalidate()
                return
            }
            
            self.progressBar.updateProgressBar()
            count += 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isJumping {
            isJumping = true
            wallaby.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            wallaby.texture = SKTexture(imageNamed: "WallabyJump")
            wallaby.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpImpulse))
        }
    }
    
    func createWallaby(for size: CGSize) {
        if self.weedCount == 0 {
            self.wallaby = SKSpriteNode(imageNamed: "WallabyDown")
            self.wallaby.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "WallabyDown"), size: CGSize(width: 50, height: 50))
        } else if self.weedCount < 3 {
            self.wallaby.texture = SKTexture(imageNamed: "WallaDrug1Down")
            self.wallaby.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "WallaDrug1Down"), size: CGSize(width: 50, height: 50))
        } else if self.weedCount < 5 {
            self.wallaby.texture = SKTexture(imageNamed: "WallaDrug2Down")
            self.wallaby.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "WallaDrug2Down"), size: CGSize(width: 50, height: 50))
        } else {
            self.wallaby.texture = SKTexture(imageNamed: "WallaDrug3Down")
            self.wallaby.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "WallaDrug3Down"), size: CGSize(width: 50, height: 50))
        }
//        wallaby = SKSpriteNode(imageNamed: "WallabyDown")
        wallaby.size = CGSize(width: 57.5, height: 58.75)
        wallaby.position = CGPoint(x: 150, y: self.size.height/2)
        wallaby.zPosition = 1
        
        wallaby.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "WallabyDown"), size: CGSize(width: 50, height: 50))
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
                if self.weedCount == 0 {
                    self.wallaby.texture = SKTexture(imageNamed: "WallabyUp")
                } else if self.weedCount < 3 {
                    self.wallaby.texture = SKTexture(imageNamed: "WallaDrug1Up")
                } else if self.weedCount < 5 {
                    self.wallaby.texture = SKTexture(imageNamed: "WallaDrug2Up")
                } else {
                    self.wallaby.texture = SKTexture(imageNamed: "WallaDrug3Up")
                }
                self.wallaby.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
            }
            let delay = SKAction.wait(forDuration: 0.4)
            let jumpSequence = SKAction.sequence([jumpAction, delay])
            let repeatJump = SKAction.repeatForever(jumpSequence)
            wallaby.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            wallaby.run(repeatJump)
        }
    }
    
    func createBackgroundAndMove(for size: CGSize) {
        
        if isFeverTime == true {
            let video = SKVideoNode(fileNamed: "BackGroundFever.mp4")
            video.position = CGPoint(x:frame.midX,y: 200)
            addChild(video)
            video.play()
        }
        let backgroundSize = CGSize(width: 1024, height: 416.5)
        let moveLeft = SKAction.moveBy(x: -backgroundSize.width, y: 0, duration: 14.0)
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
        let moveLeft = SKAction.moveBy(x: -groundSize.width, y: 0, duration: 3.5)
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
        rock.position = CGPoint(x: self.size.width + rock.size.width, y: 105)
        
        rock.physicsBody = SKPhysicsBody(texture: rock.texture!, size: randomRock == "RockL" ? CGSize(width: 55, height: 55) : CGSize(width: 35, height: 55))
        rock.physicsBody?.isDynamic = false
        
        rock.physicsBody?.categoryBitMask = rockCategory
        rock.physicsBody?.contactTestBitMask = wallabyCategory
        rock.physicsBody?.collisionBitMask = 0
        
        let moveLeft = SKAction.moveBy(x: -self.size.width - (rock.size.width * 2), y: 0, duration: randomRock == "RockL" ? 3.3 : 3.2)
        let remove = SKAction.removeFromParent()
        let moveSequence = SKAction.sequence([moveLeft, remove])
        
        rock.run(moveSequence)
        self.addChild(rock)
    }
    
    func spawnRocks() {
        let spawnRocks = SKAction.run(createRockAndMove)
        let delay = SKAction.wait(forDuration: 2, withRange: 2)
        let spawnSequence = SKAction.sequence([spawnRocks, delay])
        let spawnRepeat = SKAction.repeat(spawnSequence, count: gameTime-3)
        self.run(spawnRepeat)
    }
    
    func blinkWallaby() {
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        let blinkRepeat = SKAction.repeat(blink, count: 3)
        
        wallaby.run(blinkRepeat)
    }
    
    func pauseGame() {
        self.view?.isPaused = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.view?.isPaused = false
        }
    }
    
    func stopGame() {
        self.gameState = .success
    }
    
    func createLives() {
        for i in 0..<3 {
            lifeIcon = SKSpriteNode(imageNamed: "HeartOn")
            lifeIcon.size = CGSize(width: 20, height: 20)
            lifeIcon.position = CGPoint(x: 40 + (i * 28), y: 352)
            lifeIcon.name = "lifeIcon_\(i)"
            lifeGroup.addChild(lifeIcon)
        }
        addChild(lifeGroup)
    }
    
    func updateLives() {
        if let updatingLife = lifeGroup.childNode(withName: "lifeIcon_\(life)") as? SKSpriteNode {
            updatingLife.texture = SKTexture(imageNamed: "HeartOff")
        }
    }
    
    func reduceLife() {
        if life > 0 {
            updateLives()
            life -= 1
        } else {
            self.gameState = .gameOver
        }
    }
    
    func createHouseAndMove() {
        house = SKSpriteNode(imageNamed: "House")
        house.size = CGSize(width: 150, height: 150)
        house.position = CGPoint(x: self.size.width + house.size.width, y: 160)
    
        house.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "House"), size: house.size)
        house.physicsBody?.isDynamic = false
        
        house.physicsBody?.categoryBitMask = houseCategory
        house.physicsBody?.contactTestBitMask = wallabyCategory
        house.physicsBody?.collisionBitMask = wallabyCategory
        
        let moveLeft = SKAction.moveBy(x: -self.size.width - (house.size.width * 2), y: 0, duration: 3.9)
        house.run(moveLeft)
        self.addChild(house)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.node == wallaby || bodyB.node == wallaby {
            
            if self.weedCount == 0 {
                self.wallaby.texture = SKTexture(imageNamed: "WallabyDown")
            } else if self.weedCount < 3 {
                self.wallaby.texture = SKTexture(imageNamed: "WallaDrug1Down")
            } else if self.weedCount < 5 {
                self.wallaby.texture = SKTexture(imageNamed: "WallaDrug2Down")
            } else {
                self.wallaby.texture = SKTexture(imageNamed: "WallaDrug3Down")
            }
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
            let currentTime = Date().timeIntervalSince1970
            if let lastPaused = lastPausedTime, currentTime - lastPaused < pauseCooldown {
                return
            }
            lastPausedTime = currentTime
            blinkWallaby()
            pauseGame()
            reduceLife()
        }
        
        if wallabyBody.categoryBitMask == houseCategory || otherBody.categoryBitMask == houseCategory {
            stopGame()
        }
    }
    
    // MARK: - Fever Time
    // fever time start timer
    func startFeverTimer() {
        
        // if timer exist, stop timer
        if feverTimer != nil && feverTimer!.isValid {
            feverTimer!.invalidate()
        }
        
        if weedCount <= 2 {
            // level 1
            // 150% jump, 100% fever time
            jumpImpulse = 40
            feverTimeLength = 5
        } else if weedCount <= 4 {
            // level 2
            // 140% jump, 80% fever time
            jumpImpulse = 35
            feverTimeLength = 4
        } else {
            // level 3
            // 130% jump, 60% fever time
            jumpImpulse = 25
            feverTimeLength = 3
        }
        
        // fever time timer start
        feverTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(feverTime), userInfo: nil, repeats: false)

    }

    // when fever time started, this function is called
    @objc func feverTime() {
        
        // if fever time ends(feverTimeLength == 1), stop timer
        if(feverTimeLength == 0) {
            
            feverTimer?.invalidate()
            feverTimer = nil
            
            // after timer stopped
            endFeverTime()
        }
     
        // feverTimeLength - 1 per 1 sec
        feverTimeLength -= 1
    }
    
    func eatWeed(_ contact: SKPhysicsContact) {
        
        weedCount += 1
        
        isFeverTime = true
        startFeverTimer()
    }
    
    // when fever time end, reduce stats
    func endFeverTime() {
        
        isFeverTime = false
        
        if weedCount <= 2 {
            // level 1
            // 20% stats reduction
            jumpImpulse = 20
        } else if weedCount <= 4 {
            // level 2
            // 40% stats reduction
            jumpImpulse = 10
        } else {
            // level 3
            // 60% stats reduction
            jumpImpulse = 5
        }
    }
}
