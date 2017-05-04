//
//  WKView.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import UIKit

/// Define which properties will be inspectable in the custom `WKView`.
/// If you add a new property in this protocol, coformed classes will add the property exaclty like the following example:
///
///
///     @IBInspectable open var theNewVar: CGFloat = 0 {
///         didSet {
///             // apply new value to the layout
///         }
///     }
///
/// - Important: You must add the annotation `@IBInspectable` to show the control in the InterfaceBuilder!
public protocol PropertiesInspectable: class {
    var cornerRadius: CGFloat { get set }
    var borderWidth: CGFloat { get set }
    var borderColor: UIColor? { get set }
    var isRounded: Bool { get set }
    var shadowColor: UIColor? { get set }
}

public extension PropertiesInspectable where Self : UIView {
    
    /// Call this in `didSet` of `cornerRadius` property. MUST be called in `layoutSubviews()` to update the corner radius when layout chages.
    func updateCornerRadiusIfRounded() {
        if isRounded {
            cornerRadius = bounds.width / 2
        }
    }
}

/// This class is a simple subclass of `UIView` that adds more control in InterfaceBuilder.
/// In this framework, `UIImageView` and `UIButton` conform to `PropertiesInspectable` and have same behaviour; 
/// We will implement this common behaviour for as many as possible `UIView` classes, but remember that you can 
/// wrap a `UIView` in this `WKView`.
@IBDesignable
open class WKView: UIView, PropertiesInspectable {
    
    
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
