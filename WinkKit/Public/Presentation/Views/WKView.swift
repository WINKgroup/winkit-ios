//
//  WKView.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import UIKit

let backgroundGradientLayerName = "winkkit:backgroundGradientLayer"

/// All the key of the custom dictionary `layer.style`.
public struct WKCustomLayerStyleKey {
    
    /// To get from `layer.style` the `isRounded` state.
    public static let isRounded = "winkkit_style:isRounded"
    
    /// To get from `layer` the number of gradient colors applied.
    public static let gradientColorsNumber = "winkkit_style:gradientColorsNumber"

    /// To save colors of gradient even if count change.
    public static let gradientColors = "winkkit_style:gradientColors"

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
public protocol WKPropertiesInspectable: AnyObject {
    
    // MARK: - Properties
    
    var cornerRadius: CGFloat { get set }
    var borderWidth: CGFloat { get set }
    var borderColor: UIColor? { get set }
    var isRounded: Bool { get set }
    
    var shadowOffset: CGSize { get set }
    var shadowColor: UIColor? { get set }
    var shadowRadius: CGFloat { get set }
    var shadowOpacity: Float { get set }
    
    var gradientColorsCount: Int { get set }
    
    var gradientStartPoint: CGPoint { get set }
    var gradientEndPoint: CGPoint { get set }
    
    var gradientColor1: UIColor? { get set }
    var gradientColor2: UIColor? { get set }
    var gradientColor3: UIColor? { get set }
    
}

/// Here are all the Properties defined into `WKPropertiesInspectable`.
/// Most of the properties in the extension apply the value to the main
/// `CALayer` of the view.
@IBDesignable
extension UIView: WKPropertiesInspectable {
    
    // MARK: IBInspectable Properties
    
    /// Apply this properties to `layer.cornerRadius`.
    ///
    /// **From Apple docs:**
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
    ///
    /// **From Apple docs:**
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
    ///
    /// **From Apple docs:**
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
    
    /// If true the view will have rounded corner; if you want a circular view
    /// you just need make sure that `width == height`. If true, this property will
    /// override the `cornerRadius`. Default is false.
    ///
    /// - Important: If this property is true and you directly change the `layer.cornerRadius`, the property will be automatically set to `false`.
    @IBInspectable public var isRounded: Bool {
        get {
            return layerStyle[WKCustomLayerStyleKey.isRounded] as? Bool ?? false
        }
        set {
            applyIsRounded(value: newValue)
        }
    }
    
    /// Apply this properties to `layer.shadowColor`.
    ///
    /// **From Apple docs:**
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
    ///
    /// **From Apple docs:**
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
    ///
    /// **From Apple docs:**
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
    ///
    /// **From Apple docs:**
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
    
    /// Sets the number of gradient colors to apply. Min is 0 and it removes the gradient layer;
    /// Max is 3. Default value is 0.
    @IBInspectable public var gradientColorsCount: Int {
        get {
            return layerStyle[WKCustomLayerStyleKey.gradientColorsNumber] as? Int ?? 0
        }
        set {
            var newValue = newValue
            
            if newValue < 0 {
                newValue = 0
            } else if newValue > 3 {
                newValue = 3
            }

            layerStyle[WKCustomLayerStyleKey.gradientColorsNumber] = newValue
            refreshGradientColors()
        }
    }
    
    /// **From Apple docs:**
    /// The start point of the gradient when drawn in the layer’s coordinate space. Animatable.
    /// The start point corresponds to the first stop of the gradient. The point is defined in the unit coordinate space and is then mapped to the layer’s bounds rectangle when drawn.
    /// Default value is (0.5,0.0).
    @IBInspectable public var gradientStartPoint: CGPoint {
        get {
            return gradientLayer?.startPoint ?? .zero
        }
        set {
            gradientLayer?.startPoint = newValue
        }
    }
    
    /// **From Apple docs:**
    /// The end point of the gradient when drawn in the layer’s coordinate space. Animatable.
    /// The end point corresponds to the last stop of the gradient. The point is defined in the unit coordinate space and is then mapped to the layer’s bounds rectangle when drawn.
    /// Default value is (0.5,1.0).
    @IBInspectable public var gradientEndPoint: CGPoint {
        get {
            return gradientLayer?.endPoint ?? .zero
        }
        set {
            gradientLayer?.endPoint = newValue
        }
    }
    
    /// First of three color to apply as a gradient background. Animatable.
    @IBInspectable public var gradientColor1: UIColor? {
        get {
            let color = gradientLayer?.colors?.first
            if let color = color, let cgColor = CGColor.conditionallyCast(color) {
                return UIColor(cgColor: cgColor)
            }
            return nil
        }
        set {
            applyGradientColor(newValue, at: 0)
        }
    }
    
    /// Second of three color to apply as a gradient background. Animatable.
    @IBInspectable public var gradientColor2: UIColor? {
        get {
            let color = gradientLayer?.colors?[safe: 1]
            if let color = color, let cgColor = CGColor.conditionallyCast(color) {
                return UIColor(cgColor: cgColor)
            }
            return nil
        }
        set {
            applyGradientColor(newValue, at: 1)
        }
    }
    
    /// Third of three color to apply as a gradient background. Animatable.
    @IBInspectable public var gradientColor3: UIColor? {
        get {
            let color = gradientLayer?.colors?[safe: 2]
            if let color = color, let cgColor = CGColor.conditionallyCast(color) {
                return UIColor(cgColor: cgColor)
            }
            return nil
        }
        set {
            applyGradientColor(newValue, at: 2)
        }
    }
    
    // MARK: Internal method that are called by inspectable properties.
    
    var layerStyle: [AnyHashable: Any] {
        get {
            if layer.style == nil {
                layer.style = [WKCustomLayerStyleKey.gradientColors : [CGColor]()]
            }
            
            return layer.style!
        }
        set {
            if layer.style == nil {
                layer.style = [WKCustomLayerStyleKey.gradientColors : [CGColor]()]
            }
            
            layer.style = newValue
        }
    }
    
    @objc func applyCornerRadius(value: CGFloat) {
        if !isRounded {
            layer.cornerRadius = value
            gradientLayer?.cornerRadius = value
            updateShadowIfNeeded()
        }
    }
    
    func applyBorderWidth(value: CGFloat) {
        layer.borderWidth = value
    }
    
    func applyBorderColor(value: UIColor?) {
        layer.borderColor = value?.cgColor
    }
    
    @objc func applyIsRounded(value: Bool) {
        layerStyle[WKCustomLayerStyleKey.isRounded] = value
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
    
    func applyGradientColor(_ color: UIColor?, at index: Int) {
        var currentColors = layerStyle[WKCustomLayerStyleKey.gradientColors] as! [CGColor]
        
        if gradientColorsCount == 0 {
            removeGradientLayer()
            return
        }
        
        createGradientLayerIfNeeded()
        
        if let layer = gradientLayer, index < gradientColorsCount {
            if let color = color?.cgColor {
                currentColors.insert(color, at: index)
            } else if index < currentColors.count {
                currentColors.remove(at: index)
            }
            layerStyle[WKCustomLayerStyleKey.gradientColors] = currentColors
            layer.colors = Array(currentColors.prefix(gradientColorsCount)) // after insert, ensure max value in this array.
        }
    }
    
    func refreshGradientColors() {
        if gradientColorsCount == 0 {
            removeGradientLayer()
            return
        }
        
        createGradientLayerIfNeeded()
        
        if let layer = gradientLayer {
            layer.colors = Array((layerStyle[WKCustomLayerStyleKey.gradientColors] as! [CGColor]).prefix(gradientColorsCount))
        }
        
    }
    
    /// Call this method to re-apply the rounded corner if `isRounded == true` and `layer.cornerRadius != bounds.width / 2`.
    func roundLayerIfNeeded() {
        if isRounded && layer.cornerRadius != bounds.width / 2 {
            layer.cornerRadius = bounds.width / 2
            gradientLayer?.cornerRadius = bounds.width / 2
        }
    }
    
    /// This method apply a `CGPath` to `layer.shadowPath` with the same corner of `layer.cornerRadius`.
    /// It will work only if the new path created is different from the old one.
    func updateShadowIfNeeded() {
        guard layer.shadowOpacity > 0 else {
            return
        }
        
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
    
    /// Default gradient layer created by setting
    /// `gradientColor1`, `gradientColor2`, `gradientColor3`.
    /// This layer has a `zPosition` equals to -1 by default.
    open var gradientLayer: CAGradientLayer? {
        return layer.sublayers?.first(where: { $0.name == backgroundGradientLayerName }) as? CAGradientLayer
    }
    
    func createGradientLayerIfNeeded() {
        guard self.gradientLayer == nil else { return }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = []
        gradientLayer.frame = bounds
        gradientLayer.name = backgroundGradientLayerName
        gradientLayer.zPosition = -1
        
        layer.addSublayer(gradientLayer)
    }
    
    func removeGradientLayer() {
        gradientLayer?.removeFromSuperlayer()
    }
    
}

/// This class is a simple subclass of `UIView` that adds more control in InterfaceBuilder.
/// In this framework, `UIImageView` and `UIButton` conform to `WKPropertiesInspectable` and have same behaviour; 
/// We will implement this common behaviour for as many as possible `UIView` classes, but remember that you can 
/// wrap a `UIView` in this `WKView`.
open class WKView: UIView {
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        WKViewLifecycleImplementations.initWithFrame(in: self)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        WKViewLifecycleImplementations.initWithCoder(in: self)
    }
    
    // MARK: - Lifecycle
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        WKViewLifecycleImplementations.layoutSubviews(in: self)
    }
    
    // MARK: - deinit
    
    deinit {
        WKViewLifecycleImplementations.deinitIn(view: self)
    }
    
}

extension UIView {
    
    static var cornerRadiusObservers = [Int: NSKeyValueObservation]()
    
    var cornerRadiusObserver: NSKeyValueObservation? {
        return UIView.cornerRadiusObservers[hashValue]
    }
    
    func addCornerRadiusObserver() {
        UIView.cornerRadiusObservers[hashValue] = observe(\.layer.cornerRadius) { [weak self] (_, change) in
            guard let aliveSelf = self else { return }
            if aliveSelf.layer.cornerRadius != aliveSelf.bounds.width / 2 {
                aliveSelf.isRounded = false
            }
        }
    }
    
    func removeCornerRadiusObserver() {
        print("removeCornerRadiusObserver in \(self)")
        UIView.cornerRadiusObservers[hashValue] = nil
    }
    
}
