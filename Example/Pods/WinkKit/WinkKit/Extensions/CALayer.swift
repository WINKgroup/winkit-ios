//
//  CALayer.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 08/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

public extension CALayer {
    
    /// Add border to the `CALayer`.
    ///
    /// - Parameters:
    ///     - edges: An `OptionSet` used to tell the method what border(s) will be drawn.
    ///     - color: The color of the border.
    ///     - thickness: The thickness of the lines.
    public func wk_addBorder(edges: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
    
        switch edges {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
            break
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            break
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
            break
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}
