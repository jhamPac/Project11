//
//  GameScene.swift
//  WhackIceBirds
//
//  Created by jhampac on 1/27/16.
//  Copyright (c) 2016 jhampac. All rights reserved.
//

import SpriteKit

class GameScene: SKScene
{
    var slots = [WhackSlot]()
    var gameScore: SKLabelNode!
    var score: Int = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMoveToView(view: SKView)
    {
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
}
