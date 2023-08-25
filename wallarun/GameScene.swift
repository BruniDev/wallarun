//
//  GameScene.swift
//  wallarun
//
//  Created by 관식 on 2023/08/25.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var wallaby: SKShapeNode!
    private var ground: SKSpriteNode!
    private var isJumping: Bool = false
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .gray
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        self.physicsWorld.contactDelegate = self
        createWallaby(for: self.size)
        createGround(for: self.size)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isJumping {
            isJumping = true
            wallaby.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
        }
    }
    
    func createWallaby(for size: CGSize) {
        wallaby = SKShapeNode(circleOfRadius: 60)
        
        wallaby.fillColor = .blue
        wallaby.position = CGPoint(x: 150, y: self.size.height/2)
        
        wallaby.physicsBody = SKPhysicsBody(circleOfRadius: 60)
        wallaby.physicsBody?.isDynamic = true
        wallaby.physicsBody?.allowsRotation = false
        
        wallaby.physicsBody?.categoryBitMask = 1
        wallaby.physicsBody?.contactTestBitMask = 2
        wallaby.physicsBody?.collisionBitMask = 2
        
        self.addChild(wallaby)
    }
    
    func createGround(for size: CGSize) {
        ground = SKSpriteNode(color: .brown, size: CGSize(width: self.size.width, height: 60))
        
        ground.position = CGPoint(x: self.size.width/2, y: 20)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        
        ground.physicsBody?.categoryBitMask = 2
        ground.physicsBody?.contactTestBitMask = 1
        ground.physicsBody?.collisionBitMask = 1
        
        self.addChild(ground)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.node == wallaby || bodyB.node == wallaby {
            isJumping = false
        }
    }
}
