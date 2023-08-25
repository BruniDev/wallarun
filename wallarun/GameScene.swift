//
//  GameScene.swift
//  wallarun
//
//  Created by 관식 on 2023/08/25.
//

import SpriteKit

class GameScene: SKScene {
    
    private var wallaby: SKShapeNode!
    private var ground: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        let backgroundSound = SKAudioNode(fileNamed: "Background.mp3")
        self.addChild(backgroundSound)
        self.backgroundColor = .gray
        createWallaby(for: self.size)
        createGround(for: self.size)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        wallaby.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
    }
    
    func createWallaby(for size: CGSize) {
        wallaby = SKShapeNode(circleOfRadius: 20)
        
        wallaby.fillColor = .blue
        wallaby.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -15)
        
        wallaby.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        wallaby.physicsBody?.isDynamic = true
        wallaby.physicsBody?.allowsRotation = false
        
        self.addChild(wallaby)
    }
    
    func createGround(for size: CGSize) {
        ground = SKSpriteNode(color: .brown, size: CGSize(width: self.size.width, height: 100))
        
        ground.position = CGPoint(x: self.size.width/2, y: 50)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        
        self.addChild(ground)
    }
    
    func didBegin(contact: SKPhysicsContact) {
        
    }
}
