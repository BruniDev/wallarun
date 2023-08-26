//
//  WeedScene.swift
//  wallarun
//
//  Created by 이승용 on 2023/08/25.
//

import SpriteKit

class WeedScene: SKScene {
    
    // progress vars
    private var totalTimer: Timer?
    private let totalPlayTime: Double = 120.0   // sec
    
    // character stats vars
    private var life: Int = 3
    private var jumpHeightRatio: Float = 1.0    // multiply to applyImpulse
    private var wallabyYPosition: CGFloat?
    
    // fever time vars
    private var isFeverTime: Bool = false
    private var feverTimeLength: Double = 5.0   // sec
    
    // fever time timer vars
    private var feverTimer: Timer?
    
    // weed vars
    private var weedCount: Int = 0
    private var weedGravitation: Double = 0
    
    // collision vars
    private let rockCategory: Int = 3
    
    // MARK: - Fever Time
    // fever time start timer
    private func startFeverTimer() {
        
        // if timer exist, stop timer
        if feverTimer != nil && feverTimer!.isValid {
            feverTimer!.invalidate()
        }
        
        if weedCount <= 2 {
            // level 1
            // 150% jump, 100% fever time
            jumpHeightRatio *= 1.5
            feverTimeLength = 5
        } else if weedCount <= 4 {
            // level 2
            // 140% jump, 80% fever time
            jumpHeightRatio *= 1.4
            feverTimeLength = 4
        } else {
            // level 3
            // 130% jump, 60% fever time
            jumpHeightRatio *= 1.3
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
    
    private func eatWeed(_ contact: SKPhysicsContact) {
        
        weedCount += 1
        
        isFeverTime = true
        startFeverTimer()
    }
    
    // when fever time end, reduce stats
    private func endFeverTime() {
        
        isFeverTime = false
        
        if weedCount <= 2 {
            // level 1
            // 20% stats reduction
            jumpHeightRatio = 0.8
        } else if weedCount <= 4 {
            // level 2
            // 40% stats reduction
            jumpHeightRatio = 0.6
        } else {
            // level 3
            // 60% stats reduction
            jumpHeightRatio = 0.4
        }
    }
    
    // MARK: - [Game System] Collision with Rocks
    private func didBegin(_ contact: SKPhysicsContact){
        
        if collisionWithRock(contact) {
            if life == 1 {
                gameOver()
            } else {
                life -= 1
                collisionEffects()
            }
        }
    }
    
    private func collisionWithRock(_ contact: SKPhysicsContact) -> Bool {
        return contact.bodyA.collisionBitMask == rockCategory || contact.bodyB.collisionBitMask == rockCategory
    }
    
    // If wallaby hit to rock, 0.1초 정지 + 2초 깜빡깜빡
    private func collisionEffects() {
        
    }
    
    // If life be 0, call gameOver function
    private func gameOver() {
        
    }
    
}
