//
//  WKButton.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import UIKit

@IBDesignable
open class WKButton: UIButton, PropertiesInspectable {
    
    // MARK: Inspectable properties
    
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    /// If true the view will always have rounded corner; if you want a circular view
    /// you just need make sure that `width == height`. If true, this property will
    /// override the `cornerRadius`. Default is false.
    @IBInspectable open var isRounded: Bool = false {
        didSet {
            updateCornerRadiusIfRounded()
        }
    }
    
    @IBInspectable open var shadowColor: UIColor? {
        didSet {
            layer.shadowColor = shadowColor?.cgColor
        }
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    
    // MARK: view's lifecycle methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadiusIfRounded()
    }
}
