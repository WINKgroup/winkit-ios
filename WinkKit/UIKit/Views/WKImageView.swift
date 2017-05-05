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

    // MARK: view's lifecycle methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        print("layout subview")
        roundLayerIfNeeded()
        updateShadowIfNeeded()
    }
    
    
    // MARK: overriden `PropertiesInspectable` methods
    
    override func applyIsRounded(value: Bool) {
        super.applyIsRounded(value: value)
        roundImage()
    }
    
    override func applyCornerRadius(value: CGFloat) {
        super.applyCornerRadius(value: value)
        roundImage()
    }
    
    private func roundImage() {
        print("in roundImage")
        if let image = self.image {
            
            print("found image: rounding...")
            // Begin a new image that will be the new image with the rounded corners
            // (here with the size of an UIImageView)
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
            
            // Add a clip before drawing anything, in the shape of an rounded rect
            UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
            
            image.draw(in: bounds)
            
            // Get the image, here setting the UIImageView image
            self.image = UIGraphicsGetImageFromCurrentImageContext()
            
            // Lets forget about that we were drawing
            UIGraphicsEndImageContext()
        }
    }
    
}
