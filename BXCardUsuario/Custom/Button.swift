//
//  Button.swift
//  BXCard
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

@IBDesignable
class Button: UIButton {
    
    // MARK: - Public Properties
    @IBInspectable
    var borderColor: UIColor? = UIColor.clear {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var shadowAlpha: Float = 0.05 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var shadowBlur: CGFloat = 10.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? = UIColor.clear {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0) {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var shadowSpread: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    // MARK: - Initilization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    // MARK: - Private Methods
    func setupView() {
        layer.borderColor = borderColor?.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        
        layer.applySketchShadow(color: shadowColor ?? UIColor.clear, alpha: shadowAlpha, x: shadowOffset.width, y: shadowOffset.height, blur: shadowBlur, spread: shadowSpread)
    }
    
}
