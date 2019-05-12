//
//  WKViewLifecycleImplementations.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 12/05/2019.
//  Copyright © 2019 Wink srl. All rights reserved.
//

import Foundation

struct WKViewLifecycleImplementations {
    
    // MARK: - UIView init
    
    static func initWithFrame(in view: UIView) {
        view.addCornerRadiusObserver()
    }
    
    static func initWithCoder(in view: UIView) {
        view.addCornerRadiusObserver()
    }
    
    // MARK: - UIView Lifecycle
    
    static func layoutSubviews(in view: UIView) {
        view.roundLayerIfNeeded()
        view.updateShadowIfNeeded()
        view.gradientLayer?.frame = view.bounds
    }
    
    // MARK: - UIView deinit

    static func deinitIn(view: UIView) {
        view.removeCornerRadiusObserver()
    }
    
}
