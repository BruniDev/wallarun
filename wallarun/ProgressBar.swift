//
//  ProgressBar.swift
//  wallarun
//
//  Created by 이승용 on 2023/08/26.
//

import SpriteKit

class ProgressBar: SKNode {
    
    private var progress: CGFloat = 0
    private var maxProgress: CGFloat = 9
    private var maxProgressBarWidth: CGFloat = 0
    
    private var progressBar = SKSpriteNode()
    private var progressBarContainer = SKSpriteNode()
    
    private let progressTexture = SKTexture(imageNamed: "temp.png")
    private let progressContainerTexture = SKTexture(imageNamed: "temp.png")
    
    private var sceneFrame = CGRect()
    
    override init() {
        super.init()
    }
    
    func getSceneFrame(sceneFrame: CGRect) {
        self.sceneFrame = sceneFrame
    }
    
    func buildProgressBar() {
        progressBarContainer = SKSpriteNode(texture: progressContainerTexture, size: progressContainerTexture.size())
        progressBarContainer.size.width = sceneFrame.width * 0.5
        progressBarContainer.size.height = sceneFrame.height * 0.1
        
        progressBar = SKSpriteNode(texture: progressTexture, size: progressTexture.size())
        progressBar.size.width = 0
        progressBar.size.height = sceneFrame.height * 0.08
        progressBar.position.x = -maxProgressBarWidth / 2
        progressBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        addChild(progressBar)
        addChild(progressBarContainer)
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
