//
//  WKTextView.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/09/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import Foundation

/// The `WKTextView` extends `UITextView` and has the same `@IBInspectable` properties of `WKView`.
///
/// - SeeAlso: `WKView`
///
open class WKTextView: UITextView {
    
    // MARK: Initializers
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addCornerRadiusObserver()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addCornerRadiusObserver()
    }
    
    // MARK: UIView Lifecycle
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        roundLayerIfNeeded()
        updateShadowIfNeeded()
    }
    
    deinit {
        removeObserver(self, forKeyPath: cornerRadiusKeyPath)
    }
}
