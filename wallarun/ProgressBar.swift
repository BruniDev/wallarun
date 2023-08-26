//
//  ProgressBar.swift
//  wallarun
//
//  Created by 이승용 on 2023/08/26.
//

import SpriteKit

class ProgressBar: SKNode {
    
    private var progress: CGFloat = 0
    private var maxProgress: CGFloat = 60
    private var maxProgressBarWidth: CGFloat = 178.75
    
    private var progressBar = SKSpriteNode()
    private var progressBarContainer = SKSpriteNode()
    private var progressBarWallaby = SKSpriteNode()
    
    private let progressTexture = SKTexture(imageNamed: "ProgressBarIn.png")
    private let progressContainerTexture = SKTexture(imageNamed: "ProgressBarOut.png")
    private let progressBarWallabyTexture = SKTexture(imageNamed: "ProgressBarWallaby.png")
    
    private var sceneFrame = CGRect()
    
    override init() {
        super.init()
    }
    
    func getSceneFrame(sceneFrame: CGRect) {
        self.sceneFrame = sceneFrame
    }
    
    func buildProgressBar(for size: CGSize) {
        progressBarContainer = SKSpriteNode(texture: progressContainerTexture, size: progressContainerTexture.size())
        progressBarContainer.size.width = 240
        progressBarContainer.size.height = 24
//        progressBarContainer.position = CGPoint(x: 600, y: 30)
        progressBarContainer.position = CGPoint(x: size.width - 160, y: 30)
        
        progressBar = SKSpriteNode(texture: progressTexture, size: progressTexture.size())
        progressBar.size.width = 0
        progressBar.size.height = 6.25
        progressBar.position.x = 567
        progressBar.anchorPoint = CGPoint(x: 0, y: -4.15)
        
        // 왈라비가 따라오는건 아직 안됨
//        progressBarWallaby = SKSpriteNode(texture: progressBarWallabyTexture, size: progressBarWallabyTexture.size())
//        progressBarWallaby.position = CGPoint(x: progressBar.position.x + (CGFloat(progress / maxProgress) * maxProgressBarWidth), y: progressBar.position.y)
        
        
        addChild(progressBar)
        addChild(progressBarContainer)
        addChild(progressBarWallaby)
    }
    
    func updateProgressBar() {
        
        if progress > maxProgress { return }
        
        // update every 0.2 second
        progressBar.run(SKAction.resize(toWidth: CGFloat(progress / maxProgress) * maxProgressBarWidth, duration: 0.2))
        
        progress += 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
