//
//  WhackSlot.swift
//  WhackIceBirds
//
//  Created by jhampac on 1/27/16.
//  Copyright © 2016 jhampac. All rights reserved.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode
{
    var charNode: SKSpriteNode!
    var visible = false
    var isHit = false
    
    func configureAtPosition(pos: CGPoint)
    {
        position = pos
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    func show(hideTime hideTime: Double)
    {
        if visible { return }
        
        // set these to one because penguins scales get reduced when hit
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.runAction(SKAction.moveByX(0, y: 80, duration: 0.05))
        visible = true
        isHit = false
        
        if RandomInt(min: 0, max: 2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        }
        else
        {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        RunAfterDelay(hideTime * 3.5) {
            [unowned self] in
            self.hide()
        }
    }
    
    func hit()
    {
        isHit = true
        
        let delay = SKAction.waitForDuration(0.25)
        let hide = SKAction.moveByX(0, y: -80, duration: 0.5)
        
        // this is because show method does a check if its visible or not; if not run the show on the node
        let notVisible = SKAction.runBlock { [unowned self] in self.visible = false }
        
        let penguinHideSequence = SKAction.sequence([delay, hide, notVisible])
        
        charNode.runAction(penguinHideSequence)
    }
    
    func hide()
    {
        if !visible { return }
        charNode.runAction(SKAction.moveByX(0, y: -80, duration: 0.05))
        visible = false
    }
}
