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
    func configureAtPosition(pos: CGPoint)
    {
        position = pos
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
    }
}
