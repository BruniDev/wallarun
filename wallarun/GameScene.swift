//
//  GameScene.swift
//  wallarun
//
//  Created by 관식 on 2023/08/25.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var wallaby: SKSpriteNode!
    private var ground: SKSpriteNode!
    private var isJumping: Bool = false
    
    override func didMove(to view: SKView) {
        let backgroundSound = SKAudioNode(fileNamed: "Background.mp3")
        self.addChild(backgroundSound)
        self.backgroundColor = .white
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -30)
        self.physicsWorld.contactDelegate = self
        createWallaby(for: self.size)
        createGround(for: self.size)
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
    
    func createGround(for size: CGSize) {
        ground = SKSpriteNode(color: .brown, size: CGSize(width: self.size.width, height: 60))
        
        ground.position = CGPoint(x: self.size.width/2, y: 20)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.restitution = 0.0
        
        ground.physicsBody?.categoryBitMask = 2
        ground.physicsBody?.contactTestBitMask = 1
        ground.physicsBody?.collisionBitMask = 1
        
        self.addChild(ground)
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
