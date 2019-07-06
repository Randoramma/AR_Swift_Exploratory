//
//  VirtualPlane.swift
//  ThreeDShapes
//
//  Created by Randy McLain on 7/6/19.
//  Copyright © 2019 com.randymclain.3DShapes. All rights reserved.
//

import Foundation
import ARKit

class VirtualPlane: SCNNode {
    var anchor: ARPlaneAnchor!
    var planeGeometry: SCNPlane!
    
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x),
                                      height: CGFloat(anchor.extent.z))
        
        let material = setupPlaneMaterial()
        self.planeGeometry.materials = [material]
        
        let planeNode = SCNNode(geometry: self.planeGeometry)
        planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1.0, 0.0, 0.0)
        
        updatePlaneMaterial()
        self.addChildNode(planeNode) 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Virtual Plane Update and Setup Functions 
    internal func updateWithNewAnchor(_ anchor: ARPlaneAnchor) {
        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)
        
        self.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        
    }
    
    fileprivate func updatePlaneMaterial() {
        guard let material = self.planeGeometry.materials.first else { return }
        
        let width = Float(self.planeGeometry.width)
        let height = Float(self.planeGeometry.height)
        
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(width, height, 1.0)
    }
    
    fileprivate func setupPlaneMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white.withAlphaComponent(0.2)
        return material
    }
}
