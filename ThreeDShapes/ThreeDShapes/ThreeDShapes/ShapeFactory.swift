//
//  ShapeFactory.swift
//  ThreeDShapes
//
//  Created by Randy McLain on 7/6/19.
//  Copyright © 2019 com.randymclain.3DShapes. All rights reserved.
//

import UIKit
import ARKit

enum ShapeFactory {
    case box, sphere, pyramid, tube
    static let EDGE_LENGTH: CGFloat = 0.2
    
    var new: SCNGeometry {
        switch self {
        case .box:
            return SCNBox(width: ShapeFactory.EDGE_LENGTH,
                          height: ShapeFactory.EDGE_LENGTH,
                          length: ShapeFactory.EDGE_LENGTH,
                          chamferRadius: 0)
        case .pyramid:
            return SCNPyramid(width: ShapeFactory.EDGE_LENGTH,
                              height: ShapeFactory.EDGE_LENGTH,
                              length: ShapeFactory.EDGE_LENGTH)
        case .sphere:
            return SCNSphere(radius: ShapeFactory.EDGE_LENGTH)
        case .tube:
            return SCNTube(innerRadius: ShapeFactory.EDGE_LENGTH,
                           outerRadius: ShapeFactory.EDGE_LENGTH,
                           height: ShapeFactory.EDGE_LENGTH)
        }
    }
    
    static var count: UInt32 {
        return 4
    }
}

