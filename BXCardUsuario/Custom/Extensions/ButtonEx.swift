//
//  ButtonEx.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 05/07/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

extension Button {
    
    private var _GRADIENT_LAYER_ID: String {
        return "button_gradient_layer_id_"
    }
    
    private func getGradientLayerFor(colors: [UIColor]) -> CAGradientLayer {
        removeGradientLayer()
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint.init(x: 1.0, y: 0.5)
        gradient.name = _GRADIENT_LAYER_ID
        return gradient
    }
    
    private func removeGradientLayer() {
        if let layers = layer.sublayers {
            for layer in layers {
                if layer.name == _GRADIENT_LAYER_ID {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    func enable(_ colors: [UIColor] = Constants.COLORS._GRADIENT_ENABLED_COLORS) {
        isEnabled = true
        backgroundColor = colors.first ?? .enabledDegradeDarkColor
        //layer.insertSublayer(getGradientLayerFor(colors: colors), at: 0)
    }
    
    func disable(_ colors: [UIColor] = Constants.COLORS._GRADIENT_DISABLED_COLORS) {
        isEnabled = false
        backgroundColor = colors.first ?? .disabledDegradeDarkColor
        //layer.insertSublayer(getGradientLayerFor(colors: colors), at: 0)
    }
    
    func setGradientWith(colors: [UIColor]) {
        backgroundColor = colors.first ?? .enabledDegradeDarkColor
        //layer.insertSublayer(getGradientLayerFor(colors: colors), at: 0)
    }
    
}
