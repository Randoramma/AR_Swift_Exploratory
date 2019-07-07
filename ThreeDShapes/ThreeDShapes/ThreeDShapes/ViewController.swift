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
    var planes = [UUID: VirtualPlane]() {
        didSet {
            if planes.count > 0 {
                currentSessionStatus = .ready
                } else {
                    if currentSessionStatus == .ready {
                    currentSessionStatus = .loading
                }
            }
        }
    }
    
    var currentPlane: VirtualPlane!
    
    var currentSessionStatus = SessionState.loading {
        didSet {
            DispatchQueue.main.async {
                self.statusLabel.text = self.currentSessionStatus.rawValue
            }
            if currentSessionStatus == .failed {
                cleanUpARSession()
            }
        }
    }
    
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
        setupGestureRecognizers()
        sceneView.session.run(configuration)
        
        if planes.count > 0 {
            currentSessionStatus = .ready
        }
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
        currentSessionStatus = .failed
    }
    
    internal func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        currentSessionStatus = .tempUnavailable
    }
    
    internal func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        currentSessionStatus = .ready
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
    
    fileprivate func getVirtualPlane(touchPoint: CGPoint) -> VirtualPlane? {
        let hits = sceneView.hitTest(touchPoint, types: .existingPlaneUsingExtent)
        
        if hits.count > 0,
            let firstHit = hits.first,
            let identifier = firstHit.anchor?.identifier,
            let plane = planes[identifier] {
            
            self.currentPlane = plane
            return plane
        }
        return nil
    }
    
    // MARK: - GestureRecognizer
    
    @objc func insertShapeFrom(gestureRecognizer recognizer: UITapGestureRecognizer) {
        let locationPoint = recognizer.location(in: sceneView)
        
        if let virtualPlane = getVirtualPlane(touchPoint: locationPoint) {
            addShapesToPlane(plane: virtualPlane, atPoint: locationPoint)
        }
    }
    
    fileprivate func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(insertShapeFrom(gestureRecognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(changeShapeColorWith(gestureRecognizer:)))
        longPressGestureRecognizer.minimumPressDuration = 0.5
        
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        sceneView.addGestureRecognizer(longPressGestureRecognizer)
        
    }
    
    //MARK: - Lighting Effects
    
    fileprivate func setupLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
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
    
    fileprivate func addShapesToPlane(plane: VirtualPlane, atPoint point:CGPoint) {
        let hits = sceneView.hitTest(point, types: .existingPlaneUsingExtent)
        
        if hits.count > 0, let firstHit = hits.first {
            let translation = firstHit.worldTransform.translation
            addShape(x: translation.x, y: translation.y, z: translation.z)
        }
    }
    
    @objc fileprivate func changeShapeColorWith(gestureRecognizer recognizer: UILongPressGestureRecognizer) {
        let touchLocation = recognizer.location(in: sceneView)
        let hits = sceneView.hitTest(touchLocation)
        
        if !hits.isEmpty, let firstHit = hits.first {
            let firstNode = firstHit.node
            guard shapeNodes.contains(firstNode) else { return }
            firstNode.geometry?.firstMaterial?.diffuse.contents = UIColor.randomColor()
        }
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
        setupLighting()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
    }
    
    fileprivate func cleanUpARSession() {
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
    }
}
