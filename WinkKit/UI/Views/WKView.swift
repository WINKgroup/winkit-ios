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
public protocol WKPropertiesInspectable: class {
    
    // MARK: - Properties
    
    var cornerRadius: CGFloat { get set }
    var borderWidth: CGFloat { get set }
    var borderColor: UIColor? { get set }
    var isRounded: Bool { get set }
    
    var shadowOffset: CGSize { get set }
    var shadowColor: UIColor? { get set }
    var shadowRadius: CGFloat { get set }
    var shadowOpacity: Float { get set }
}

/// Here are all the Properties defined into `WKPropertiesInspectable`.
/// Most of the properties in the extension apply the value to the main
/// `CALayer` of the view.
@IBDesignable
extension UIView: WKPropertiesInspectable {
    
    // MARK: IBInspectable Properies
    
    /// Apply this properties to `layer.cornerRadius`.
    /// The radius to use when drawing rounded corners for the layer’s background. Animatable.
    /// Setting the radius to a value greater than 0.0 causes the layer to begin drawing rounded corners on its background. 
    /// By default, the corner radius does not apply to the image in the layer’s contents property; it applies only to the background color and border of the layer. 
    /// However, setting the masksToBounds property to true causes the content to be clipped to the rounded corners.
    /// The default value of this property is 0.0.
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
           applyCornerRadius(value: newValue)
        }
    }
    
    /// Apply this properties to `layer.borderWidth`.
    /// The width of the layer’s border. Animatable.
    /// When this value is greater than 0.0, the layer draws a border using the current borderColor value. 
    /// The border is drawn inset from the receiver’s bounds by the value specified in this property. 
    /// It is composited above the receiver’s contents and sublayers and includes the effects of the cornerRadius property.
    /// The default value of this property is 0.0.
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            applyBorderWidth(value: newValue)
        }
    }
    
    /// Apply this properties to `layer.borderColor`.
    /// The color of the layer’s border. Animatable.
    /// The default value of this property is an opaque black color.
    /// The value of this property is retained using the Core Foundation retain/release semantics. 
    /// This behavior occurs despite the fact that the property declaration appears to use the default assign semantics for object retention.
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
    
    /// Apply this properties to `layer.shadowColor`.
    /// The color of the layer’s shadow. Animatable.
    /// The default value of this property is an opaque black color.
    /// The value of this property is retained using the Core Foundation retain/release semantics. 
    /// This behavior occurs despite the fact that the property declaration appears to use the default assign semantics for object retention.
    @IBInspectable public var shadowColor: UIColor? {
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
    
    /// Apply this properties to `layer.shadowOpacity`.
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

    /// Apply this properties to `layer.shadowOffset`.
    /// The offset (in points) of the layer’s shadow. Animatable.
    /// The default value of this property is (0.0, -3.0).
    @IBInspectable public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            applyShadowOffset(value: newValue)
        }
    }
    
    /// Apply this properties to `layer.shadowRadius`.
    /// The blur radius (in points) used to render the layer’s shadow. Animatable.
    /// You specify the radius The default value of this property is 3.0.
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
/// In this framework, `UIImageView` and `UIButton` conform to `WKPropertiesInspectable` and have same behaviour; 
/// We will implement this common behaviour for as many as possible `UIView` classes, but remember that you can 
/// wrap a `UIView` in this `WKView`.
open class WKView: UIView {
        
    // MARK: UIView Lifecycle
    
    open override var clipsToBounds: Bool {
        didSet {
            applyClipToBounds()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        roundLayerIfNeeded()
        updateShadowIfNeeded()
    }
    
    
}
