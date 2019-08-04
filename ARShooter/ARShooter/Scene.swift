//
//  Scene.swift
//  ARShooter
//
//  Created by Randy McLain on 7/29/19.
//  Copyright © 2019 com.randymclain.ARShooter. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    
    static let REAL_WORLD_DIMENSION_IN_METERS = 2
    
    var sceneView: ARSKView {
        return view as! ARSKView
    }
    
    var worldFirstSetup = false
    
    override func didMove(to view: SKView) {
        sight = SKSpriteNode(imageNamed: "crosshair")
        addChild(sight)
        
        srand48(Int(Date.timeIntervalSinceReferenceDate))
    }
    
    var sight: SKSpriteNode!
    
    let gameSize = CGSize(width: REAL_WORLD_DIMENSION_IN_METERS,
                          height: REAL_WORLD_DIMENSION_IN_METERS)
    
    var hitCount = 0
    
    override func update(_ currentTime: TimeInterval) {
        if !worldFirstSetup {
            setupWorld()
        }
        
        guard let currentFrame = sceneView.session.currentFrame, let lightEstimate = currentFrame.lightEstimate else { return }
        
        let neutralIntensity: CGFloat = 1000
        let ambientIntensity = min(lightEstimate.ambientIntensity, neutralIntensity)
        let blendFactor = 1 - ambientIntensity / neutralIntensity
        
        for node in children {
            if let monster = node as? SKLabelNode {
                monster.color = .black
                monster.colorBlendFactor = blendFactor
            }
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        let location = sight.position
        let hitNodes = nodes(at: location)
        
        var hitMonster: SKNode?
        
        for node in hitNodes {
            if node.name == "monster" {
                hitMonster = node
                print("💥 monster was hit!💥")
                break
            }
        }
        
        print("We fired.")
        run(Sounds.fire)
        
        if let hitMonster = hitMonster,
            let anchor = sceneView.anchor(for: hitMonster) {
            let action = SKAction.run {
                self.sceneView.session.remove(anchor: anchor)
            }
            let group = SKAction.group([Sounds.hit, action])
            let sequence = [SKAction.wait(forDuration: 0.3), group]
            hitMonster.run(SKAction.sequence(sequence))
            
            hitCount += 1
            
            if hitCount == 3 {
                hitCount = 0
                setupWorld()
            }
        }
    }
    
    //MARK: - Setup World when game is loaded
    func setupWorld() {
        guard let currentFrame = sceneView.session.currentFrame, let scene = SKScene(fileNamed: "Scene") else { return }
        
        for node in scene.children {
            if let node = node as? SKSpriteNode {
                var translation = matrix_identity_float4x4
                
                let positionX = node.position.x / scene.size.width
                let positionY = node.position.y / scene.size.height
                
                translation.columns.3.x = Float(positionX * gameSize.width)
                translation.columns.3.z = Float(positionY * gameSize.height)
                translation.columns.3.y = -Float(drand48() - 0.5) // the drand value with offset allows a height value to be randomly generated somewhere between 0.5m above or below the device.
                let transform = currentFrame.camera.transform * translation
                let anchor = ARAnchor(transform: transform)
                sceneView.session.add(anchor: anchor) // add anchor to scene triggering delegate method.
            }
        }
        worldFirstSetup = true
    }
    
    
}
