//
//  GameScene.swift
//  WhackIceBirds
//
//  Created by jhampac on 1/27/16.
//  Copyright (c) 2016 jhampac. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene
{
    var slots = [WhackSlot]()
    var gameScore: SKLabelNode!
    var popupTime = 0.85
    var score: Int = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMoveToView(view: SKView)
    {
        let delay = 1.0
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .Left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0..<5 { createSlotAt(CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0..<4 { createSlotAt(CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0..<5 { createSlotAt(CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0..<4 { createSlotAt(CGPoint(x: 180 + (i * 170), y: 140)) }
        
        dispatch_after(time, dispatch_get_main_queue()) { [unowned self] in
            self.createEnemy()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
    
    }
    
    func createSlotAt(pos: CGPoint)
    {
        let slot = WhackSlot()
        slot.configureAtPosition(pos)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy()
    {
        popupTime *= 0.991
        
        // Every time we call createEnemy we randomize the array of penguin nodes
        slots = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(slots) as! [WhackSlot]
        slots[0].show(hideTime: popupTime)
        
        if RandomInt(min: 0, max: 12) > 4 { slots[1].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 8 {  slots[2].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 10 { slots[3].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 11 { slots[4].show(hideTime: popupTime)    }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        
        RunAfterDelay(RandomDouble(min: minDelay, max: maxDelay)) { [unowned self] in
            self.createEnemy()
        }
    }
}
