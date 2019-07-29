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
        // Setup your scene here
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !worldFirstSetup {
            setupWorld()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        // Create anchor using the camera's current position
        if let currentFrame = sceneView.session.currentFrame {
            
            // Create a transform with a translation of 0.2 meters in front of the camera
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.2
            let transform = simd_mul(currentFrame.camera.transform, translation)
            
            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
        }
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
