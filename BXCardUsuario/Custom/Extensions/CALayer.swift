//
//  CALayer.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 05/07/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

extension CALayer {
    
    func applySketchShadow(color: UIColor = .black, alpha: Float = 0.1, x: CGFloat = 0, y: CGFloat = 5, blur: CGFloat = 10, spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
}
