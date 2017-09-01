//
//  UIImage.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 08/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import UIKit.UIImage

public extension UIImage {
    
    // MARK: - Methods
    
    /// Return the same UIImage with gray scale colors.
    public func wk_convertedToGrayScale() -> UIImage {
        let imageRect:CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = size.width
        let height = size.height
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.draw(cgImage!, in: imageRect)
        let imageRef = context!.makeImage()
        let newImage = UIImage(cgImage: imageRef!)
        
        return newImage
    }

}
