//
//  Types.swift
//  ARShooter
//
//  Created by Randy McLain on 8/2/19.
//  Copyright © 2019 com.randymclain.ARShooter. All rights reserved.
//

import SpriteKit

enum Sounds {
    static let fire = SKAction.playSoundFileNamed("gunshot.wav", waitForCompletion: false)
    static let hit = SKAction.playSoundFileNamed("hit.wav", waitForCompletion:  false)
}
