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
    var numRounds = 0
    var score: Int = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    // this is like the main entry point; load this scence in viewDidLoad in the controller
    override func didMoveToView(view: SKView)
    {
        let delay = 1.0
        
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
        
        RunAfterDelay(delay) {
            [unowned self] in
            self.createEnemy()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if let touch = touches.first
        {
            let location = touch.locationInNode(self)
            let nodes = nodesAtPoint(location)
            
            for node in nodes
            {
                if node.name == "charFriend"
                {
                    // no whacking
                    let whackSlot = node.parent!.parent as! WhackSlot
                    if !whackSlot.visible { continue }
                    if whackSlot.isHit { continue }
                    
                    whackSlot.hit()
                    score -= 5
                    
                    runAction(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                    
                }
                else if node.name == "charEnemy"
                {
                    // yes whacking
                    let whackSlot = node.parent!.parent as! WhackSlot
                    if !whackSlot.visible {continue}
                    if whackSlot.isHit {continue}
                    
                    whackSlot.charNode.xScale = 0.85
                    whackSlot.charNode.yScale = 0.85
                    
                    whackSlot.hit()
                    ++score
                    
                    runAction(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                }
            }
        }
    }
    
    func createSlotAt(pos: CGPoint)
    {
        let slot = WhackSlot()
        slot.configureAtPosition(pos)
        addChild(slot)
        slots.append(slot)
    }
    
    // this function gets called repeatedly with a delay
    func createEnemy()
    {
        ++numRounds
        
        if numRounds >= 30
        {
            for slot in slots
            {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            // after this don't continue create enemey method
            return
        }
        
        popupTime *= 0.991
        
        // Every time we call createEnemy we randomize the array of penguin nodes
        slots = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(slots) as! [WhackSlot]
        slots[0].show(hideTime: popupTime)
        
        // so for a very call do one of this one offs; if the condition passes run function, if not we don't care
        if RandomInt(min: 0, max: 12) > 4 { slots[1].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 8 {  slots[2].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 10 { slots[3].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 11 { slots[4].show(hideTime: popupTime) }
        
        // get a min and max of the dynamic popupTime popupTime * make me smaller with every call
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        
        let dl = RandomDouble(min: minDelay, max: maxDelay)
        
        RunAfterDelay(dl) {
            [unowned self] in
            self.createEnemy()
        }
    }
}
