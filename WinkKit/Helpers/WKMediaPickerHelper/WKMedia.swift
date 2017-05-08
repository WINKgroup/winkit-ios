//
//  WKMedia.swift
//  CityNews
//
//  Created by Rico Crescenzio on 06/12/16.
//  Copyright © 2016 Wink. All rights reserved.
//

import UIKit

///Protocol used to make video and image of the same type.
public protocol WKMedia: CustomStringConvertible {
    var previewImage: UIImage { get }
    var name: String { get }
}

/// A struct that contains the video url and a thumbnail of it.
public struct WKMediaVideo: WKMedia {
    public var previewImage: UIImage { return thumbnail }
    
    public let name: String
    public let url: URL
    public let thumbnail: UIImage
}

public extension WKMediaVideo {
    var description: String {
        return "url: \(url) - thumb: \(thumbnail)"
    }
}


/// A struct that contains the image media.
public struct WKMediaImage: WKMedia {
    public var previewImage: UIImage { return image }
    
    public let name: String
    public let image: UIImage
    public let jpegCompressedData: Data
    public let quality: CGFloat
}

public extension WKMediaImage {
    var description: String {
        return "image: \(image)"
    }
}
