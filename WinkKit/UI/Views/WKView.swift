//
//  WKView.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import UIKit

/// All the key of the custom dictionary `layer.style`.
public struct WKCustomLayerStyleKey {
    
    /// To get from `layer.style` the `isRounded` state.
    public static let isRounded = "isRounded"
}

/// Define which properties will be inspectable in the custom `WKView`.
/// If you add a new property in this protocol, coformed classes will add the property
/// in the `UIView` extension exactly like the following example:
///
///
///     @IBInspectable open var theNewVar: CGFloat {
///         get {
///             // reutrn the value
///         }
///         set {
///             // set the new value
///         }
///     }
///
/// - Important: You must add the annotation `@IBInspectable` to show the control in the InterfaceBuilder!
public protocol PropertiesInspectable: class {
    var cornerRadius: CGFloat { get set }
    var borderWidth: CGFloat { get set }
    var borderColor: UIColor? { get set }
    var isRounded: Bool { get set }
    
    var shadowOffset: CGSize { get set }
    var shadowColor: UIColor? { get set }
    var shadowRadius: CGFloat { get set }
    var shadowOpacity: Float { get set }
}

@IBDesignable
extension UIView: PropertiesInspectable {
    
    // MARK: inspectable properies
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
           applyCornerRadius(value: newValue)
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            applyBorderWidth(value: newValue)
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            applyBorderColor(value: newValue)
        }
    }
    
    /// If true the view will always have rounded corner; if you want a circular view
    /// you just need make sure that `width == height`. If true, this property will
    /// override the `cornerRadius`. Default is false.
    @IBInspectable public var isRounded: Bool {
        get {
            return layer.style?[WKCustomLayerStyleKey.isRounded] as? Bool ?? false
        }
        set {
            applyIsRounded(value: newValue)
        }
    }
    
    /// The color of the shadow. Defaults to opaque black. Colors created
    /// from patterns are currently NOT supported. Animatable.
    @IBInspectable public
    
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
        set {
            applyShadowColor(value: newValue)
        }
    }
    
    /// The opacity of the shadow. Defaults to 0. Specifying a value outside the
    /// [0,1] range will give undefined results. Animatable.
    @IBInspectable public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            applyShadowOpacity(value: newValue)
        }
    }
    
    /// The shadow offset. Defaults to (0, -3). Animatable.
    @IBInspectable public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            applyShadowOffset(value: newValue)
        }
    }
    
    /// The blur radius used to create the shadow. Defaults to 3. Animatable.
    @IBInspectable public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            applyShadowRadius(value: newValue)
        }
    }
    
    // MARK: Internal method that are called by inspectable properties.
    
    func applyCornerRadius(value: CGFloat) {
        if !isRounded {
            layer.cornerRadius = value
            updateShadowIfNeeded()
        }
    }
    
    func applyBorderWidth(value: CGFloat) {
        layer.borderWidth = value
    }
    
    func applyBorderColor(value: UIColor?) {
         layer.borderColor = value?.cgColor
    }
    
    func applyIsRounded(value: Bool) {
        layer.style = [WKCustomLayerStyleKey.isRounded : value]
        roundLayerIfNeeded()
        updateShadowIfNeeded()
    }
    
    func applyShadowColor(value: UIColor?) {
        layer.shadowColor = value?.cgColor
    }
    
    func applyShadowOpacity(value: Float) {
        layer.shadowOpacity = value
    }
    
    func applyShadowOffset(value: CGSize) {
        layer.shadowOffset = value
    }
    
    func applyShadowRadius(value: CGFloat) {
        layer.shadowRadius = value
    }
    
    /// Call this method to re-apply the rounded corner if `isRounded == true` and `layer.cornerRadius != bounds.width / 2`.
    func roundLayerIfNeeded() {
        if isRounded && layer.cornerRadius != bounds.width / 2 {
            layer.cornerRadius = bounds.width / 2
        }
    }
    
    /// This method apply a `CGPath` to `layer.shadowPath` with the same corner of `layer.cornerRadius`.
    /// It will work only if the new path created is different from the old one.
    func updateShadowIfNeeded() {
        let newPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
        if let path = layer.shadowPath, path == newPath {
            return
        }
        
        layer.shadowPath = newPath
        let backgroundCGColor = self.backgroundColor?.cgColor
        self.backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
        
        layer.masksToBounds = false
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    func applyClipToBounds() {
        
    }
}

/// This class is a simple subclass of `UIView` that adds more control in InterfaceBuilder.
/// In this framework, `UIImageView` and `UIButton` conform to `PropertiesInspectable` and have same behaviour; 
/// We will implement this common behaviour for as many as possible `UIView` classes, but remember that you can 
/// wrap a `UIView` in this `WKView`.
open class WKView: UIView {
        
    // MARK: view's lifecycle methods
    
    open override var clipsToBounds: Bool {
        didSet {
            applyClipToBounds()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        print("layout subview")
        roundLayerIfNeeded()
        updateShadowIfNeeded()
    }
    
    
}
