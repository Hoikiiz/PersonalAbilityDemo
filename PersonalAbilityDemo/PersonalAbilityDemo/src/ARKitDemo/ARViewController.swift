//
//  ARViewController.swift
//  PersonalAbilityDemo
//
//  Created by SunYang on 2018/8/2.
//  Copyright © 2018年 SunYang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var endButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()//SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.session.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    
    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    var count = 1
    var second = 1.0
    // MARK: - ARSessionDelegate
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if count % 20 == 0 && shouldAddNode {
            let node = SCNNode()
            node.geometry = SCNPlane(width: 0.128, height: 0.072)
            let column = frame.camera.transform.columns.3
            node.position = SCNVector3Make(column.x, column.y, column.z - 0.2)
            
            let material = node.geometry?.firstMaterial!
            if let contentImage = ThumbImageManager.init().getImage(start: second) {
                material?.diffuse.contents = contentImage
                material?.isDoubleSided = true
                material?.ambient.contents = UIColor.black
                material?.lightingModel = .constant
                sceneView.scene.rootNode.addChildNode(node)
                second += 0.5
            } else {
                endSession(endButton)
            }
        }
        count += 1
    }
    
    // MARK: - Actions
    var shouldAddNode = false
    @IBAction func beginSession(_ sender: Any) {
        shouldAddNode = true
        statusLabel.text = "Begin Printing"
    }
    
    @IBAction func endSession(_ sender: Any) {
        shouldAddNode = false
        statusLabel.text = "End Printing"
    }
    @IBAction func removeAllMode(_ sender: Any) {
        for node in sceneView.scene.rootNode.childNodes {
            node.removeFromParentNode()
        }
        statusLabel.text = "Nodes removed"
    }
    

}
