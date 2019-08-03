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
    
    
    var sceneView: ARSKView {
        return view as! ARSKView
    }
    
    var worldFirstSetup = false
    override func didMove(to view: SKView) {
        sight = SKSpriteNode(imageNamed: "crosshair")
        addChild(sight)
    }
    
    var sight: SKSpriteNode!
    
    
    
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
    }
    
    //MARK: - Setup World when game is loaded
    func setupWorld() {
        guard let currentFrame = sceneView.session.currentFrame else { return }
        
        var translation = matrix_identity_float4x4 // create identity matrix
        translation.columns.3.z = -0.3 // create translation matrix
        let transform = currentFrame.camera.transform * translation // update translation matrix with transform
        
        let anchor = ARAnchor(transform: transform) // create anchor using transform matrix
        sceneView.session.add(anchor: anchor) // add anchor to scene triggering delegate method.
            
            
        worldFirstSetup = true
    }
    
    
}
