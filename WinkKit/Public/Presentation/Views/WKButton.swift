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
