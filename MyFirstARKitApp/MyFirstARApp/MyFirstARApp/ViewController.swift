//
//  ViewController.swift
//  MyFirstARApp
//
//  Created by Randy McLain on 7/4/19.
//  Copyright © 2019 com.randymclain.MyArKitApp. All rights reserved.
//

import UIKit
import ARKit

final class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let config = ARWorldTrackingConfiguration()
        sceneView.session.run(config, options: .removeExistingAnchors)
        
        addCube()
        addTapGestureRecognizerToSceneView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
        removeTapGestureRecognizerFromSceneView()
    }
    
    //MARK: - Add Cube
    
    /// position relative to camera (X, Y, Z)
    /// params:
    /// x = neg left < - > pos right
    /// y = neg doqwn < - > pos up
    /// z = neg forwards < - > pos backwards or away
    
    private func addCube(x: Float = 0, y: Float = 0, z: Float = -0.5) {
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
        
        let cubeNode = SCNNode()
        cubeNode.geometry = cube
        cubeNode.position = SCNVector3(x, y, z)
    
        sceneView.scene.rootNode.addChildNode(cubeNode)
    }
    
    //MARK: - GestureRecognizers
    
    private func addTapGestureRecognizerToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func removeTapGestureRecognizerFromSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.removeGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func didTap( withGestureRecognizer recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        
        guard let node = hitTestResults.first?.node else {
            let hitTestResultWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            if let hitTestResultWithFirstFeaturePoint = hitTestResultWithFeaturePoints.first {
                let translation = hitTestResultWithFirstFeaturePoint.worldTransform.translation
                addCube(x: translation.x, y: translation.y, z: translation.z)
            }
            
         return
        }
        node.removeFromParentNode()
    }
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

