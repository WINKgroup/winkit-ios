//
//  WKButton.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import UIKit

/// The `WKButton` extends `UIButton` and has the same `@IBInspectable` properties of `WKView`.
/// 
/// - SeeAlso: `WKView`
///
open class WKButton: UIButton {
    
    // MARK: Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
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
