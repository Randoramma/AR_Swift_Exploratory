//
//  Extensions.swift
//  ThreeDShapes
//
//  Created by Randy McLain on 7/6/19.
//  Copyright © 2019 com.randymclain.3DShapes. All rights reserved.
//

import Foundation
import ARKit


extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random())/CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(displayP3Red: .random(), green: .random(), blue: .random(), alpha: 1.0)
    }
}

