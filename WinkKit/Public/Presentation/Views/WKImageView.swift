//
//  WKImageView.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/05/17.
//
//

import UIKit

@IBDesignable
open class WKImageView: UIImageView {
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        WKViewLifecycleImplementations.initWithFrame(in: self)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        WKViewLifecycleImplementations.initWithCoder(in: self)
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        addCornerRadiusObserver()
    }
    
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        addCornerRadiusObserver()
    }
    
    // MARK: - Lifecycle
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        WKViewLifecycleImplementations.layoutSubviews(in: self)
    }
    
    // MARK: Overriden `WKPropertiesInspectable` methods
    
    override func applyIsRounded(value: Bool) {
        super.applyIsRounded(value: value)
        roundImage()
    }
    
    override func applyCornerRadius(value: CGFloat) {
        super.applyCornerRadius(value: value)
        roundImage()
    }
    
    // MARK: - Private Methods
    
    private func roundImage() {
        guard let image = image else { return }
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
        image.draw(in: bounds)
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    // MARK: - deinit
    
    deinit {
        WKViewLifecycleImplementations.deinitIn(view: self)
    }
    
}
