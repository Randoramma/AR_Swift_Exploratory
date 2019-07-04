//
//  ViewController.swift
//  MyFirstARApp
//
//  Created by Randy McLain on 7/4/19.
//  Copyright © 2019 com.randymclain.MyArKitApp. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    private func addCube() {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
        
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(0,0,-0.6) // position relative to camera (X, Y, Z)
        
        // X = neg left < - > pos right
        // Y = neg doqwn < - > pos up
        // Z = neg forwards < - > pos backwards or away
    
        let scene = SCNScene()
        scene.rootNode.addChildNode(boxNode)
        sceneView.scene = scene
        }
    
    //MARK: - GestureRecognizers
    
    private func addTapGestureRecognizerToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func removeTapGestureRecognizerFromSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(withGestureRecognizer:)))
        sceneView.removeGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func didTap( withGestureRecognizer recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        
        guard let node = hitTestResults.first?.node else { return }
        node.removeFromParentNode()
    }
    
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

