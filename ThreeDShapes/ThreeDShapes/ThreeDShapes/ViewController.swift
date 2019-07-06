//
//  ViewController.swift
//  ThreeDShapes
//
//  Created by Randy McLain on 7/5/19.
//  Copyright © 2019 com.randymclain.3DShapes. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    
    let shapeForValue : [UInt32: ShapeFactory] = [0: .box,
                                                  1: .sphere,
                                                  2: .pyramid,
                                                  3: .tube]
    
    var shapeNodes = [SCNNode]()
    var planes = [UUID: VirtualPlane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.planeDetection = .vertical // added
        
        // calling this from viewWillAppear as if this is only called from VDL it will not be renewed each time the VC is loaded.. yet unsure if this should be reran each time the view appears but it usually is.
        setupScene()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    internal func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    internal func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    internal func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // MARK: - Plane Detection Delegate
    
    // called when the camera moves or movement around the scene
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor, let plane = planes[planeAnchor.identifier] {
            plane.updateWithNewAnchor(planeAnchor)
        }
    }
    
    // called when new nodes are added to the scene
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            let plane = VirtualPlane(anchor: planeAnchor)
            self.planes[planeAnchor.identifier] = plane
            node.addChildNode(plane)
            
        }
    }
    
    // called when new nodes are removed to the scene
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor, let index = planes.index(forKey: planeAnchor.identifier) {
            planes.remove(at: index)
        }
    }
    
    // MARK: - ShapeManagement
    
    fileprivate func addShape(x: Float = 0, y: Float = 0, z: Float = -0.6) {
        let count = ShapeFactory.count
        let index = arc4random_uniform(count) // create a random number to pick a random shape
        let currentShape = shapeForValue[index]?.new
        let shapeNode = SCNNode()
        shapeNode.geometry = currentShape
        shapeNode.position = SCNVector3(x: x, y: y, z: z)
        
        shapeNodes.append(shapeNode)
        sceneView.scene.rootNode.addChildNode(shapeNode)
    }
    
    // MARK: - Setup
    
    fileprivate func setupLabel() {
        statusLabel.layer.cornerRadius = 20
        statusLabel.layer.masksToBounds = true
    }
    
    fileprivate func setupScene() {
        sceneView.delegate = self
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        setupLabel()
        addShape()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
    }
}
