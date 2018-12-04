//
//  MimeType.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 03/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation

/// Map most common mime types in enum. Some cases may have same string representation, like `html` and `htm`.
/// The `CustomStringConvertible`, `Equatable`, `Hashable` conformance are made using the `string` computed property of the enum. This means that different cases may have the same `description`, `hashValue` or may be equals to other cases. For example `html` == `htm` returns `true` because the rawValue is the the same for both cases. If you need a special mime type non listed here, use case `.custom(string:)`.
public enum MimeType {
    case urlEncoded
    case multipart
    case plist
    case html
    case htm
    case shtml
    case css
    case xml
    case gif
    case jpeg
    case jpg
    case js
    case atom
    case rss
    case mml
    case txt
    case jad
    case wml
    case htc
    case png
    case tif
    case tiff
    case wbmp
    case ico
    case jng
    case bmp
    case svg
    case svgz
    case webp
    case woff
    case jar
    case war
    case ear
    case json
    case hqx
    case doc
    case pdf
    case ps
    case eps
    case ai
    case rtf
    case m3u8
    case xls
    case eot
    case ppt
    case wmlc
    case kml
    case kmz
    case compressed7z
    case cco
    case jardiff
    case jnlp
    case run
    case pl
    case pm
    case prc
    case pdb
    case rar
    case rpm
    case sea
    case swf
    case sit
    case tcl
    case tk
    case der
    case pem
    case crt
    case xpi
    case xhtml
    case xspf
    case zip
    case bin
    case exe
    case dll
    case deb
    case dmg
    case iso
    case img
    case msi
    case msp
    case msm
    case docx
    case xlsx
    case pptx
    case mid
    case midi
    case kar
    case mp3
    case ogg
    case m4a
    case ra
    case video3gpp
    case video3gp
    case ts
    case mp4
    case mpeg
    case mpg
    case mov
    case webm
    case flv
    case m4v
    case mng
    case asx
    case asf
    case wmv
    case avi
    
    case custom(string: String)
    
    public var string: String {
        switch self {
        case .urlEncoded: return "application/x-www-form-urlencoded"
        case .multipart: return "multipart/form-data"
        case .plist: return "application/x-plist"
        case .html: return "text/html"
        case .htm: return "text/html"
        case .shtml: return "text/html"
        case .css: return "text/css"
        case .xml: return "text/xml"
        case .gif: return "image/gif"
        case .jpeg: return "image/jpeg"
        case .jpg: return "image/jpeg"
        case .js: return "application/javascript"
        case .atom: return "application/atom+xml"
        case .rss: return "application/rss+xml"
        case .mml: return "text/mathml"
        case .txt: return "text/plain"
        case .jad: return "text/vnd.sun.j2me.app-descriptor"
        case .wml: return "text/vnd.wap.wml"
        case .htc: return "text/x-component"
        case .png: return "image/png"
        case .tif: return "image/tiff"
        case .tiff: return "image/tiff"
        case .wbmp: return "image/vnd.wap.wbmp"
        case .ico: return "image/x-icon"
        case .jng: return "image/x-jng"
        case .bmp: return "image/x-ms-bmp"
        case .svg: return "image/svg+xml"
        case .svgz: return "image/svg+xml"
        case .webp: return "image/webp"
        case .woff: return "application/font-woff"
        case .jar: return "application/java-archive"
        case .war: return "application/java-archive"
        case .ear: return "application/java-archive"
        case .json: return "application/json"
        case .hqx: return "application/mac-binhex40"
        case .doc: return "application/msword"
        case .pdf: return "application/pdf"
        case .ps: return "application/postscript"
        case .eps: return "application/postscript"
        case .ai: return "application/postscript"
        case .rtf: return "application/rtf"
        case .m3u8: return "application/vnd.apple.mpegurl"
        case .xls: return "application/vnd.ms-excel"
        case .eot: return "application/vnd.ms-fontobject"
        case .ppt: return "application/vnd.ms-powerpoint"
        case .wmlc: return "application/vnd.wap.wmlc"
        case .kml: return "application/vnd.google-earth.kml+xml"
        case .kmz: return "application/vnd.google-earth.kmz"
        case .compressed7z: return "application/x-7z-compressed"
        case .cco: return "application/x-cocoa"
        case .jardiff: return "application/x-java-archive-diff"
        case .jnlp: return "application/x-java-jnlp-file"
        case .run: return "application/x-makeself"
        case .pl: return "application/x-perl"
        case .pm: return "application/x-perl"
        case .prc: return "application/x-pilot"
        case .pdb: return "application/x-pilot"
        case .rar: return "application/x-rar-compressed"
        case .rpm: return "application/x-redhat-package-manager"
        case .sea: return "application/x-sea"
        case .swf: return "application/x-shockwave-flash"
        case .sit: return "application/x-stuffit"
        case .tcl: return "application/x-tcl"
        case .tk: return "application/x-tcl"
        case .der: return "application/x-x509-ca-cert"
        case .pem: return "application/x-x509-ca-cert"
        case .crt: return "application/x-x509-ca-cert"
        case .xpi: return "application/x-xpinstall"
        case .xhtml: return "application/xhtml+xml"
        case .xspf: return "application/xspf+xml"
        case .zip: return "application/zip"
        case .bin: return "application/octet-stream"
        case .exe: return "application/octet-stream"
        case .dll: return "application/octet-stream"
        case .deb: return "application/octet-stream"
        case .dmg: return "application/octet-stream"
        case .iso: return "application/octet-stream"
        case .img: return "application/octet-stream"
        case .msi: return "application/octet-stream"
        case .msp: return "application/octet-stream"
        case .msm: return "application/octet-stream"
        case .docx: return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case .xlsx: return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        case .pptx: return "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        case .mid: return "audio/midi"
        case .midi: return "audio/midi"
        case .kar: return "audio/midi"
        case .mp3: return "audio/mpeg"
        case .ogg: return "audio/ogg"
        case .m4a: return "audio/x-m4a"
        case .ra: return "audio/x-realaudio"
        case .video3gpp: return "video/3gpp"
        case .video3gp: return "video/3gpp"
        case .ts: return "video/mp2t"
        case .mp4: return "video/mp4"
        case .mpeg: return "video/mpeg"
        case .mpg: return "video/mpeg"
        case .mov: return "video/quicktime"
        case .webm: return "video/webm"
        case .flv: return "video/x-flv"
        case .m4v: return "video/x-m4v"
        case .mng: return "video/x-mng"
        case .asx: return "video/x-ms-asf"
        case .asf: return "video/x-ms-asf"
        case .wmv: return "video/x-ms-wmv"
        case .avi: return "video/x-msvideo"
        case .custom(let string): return string
        }
    }
}

extension MimeType: CustomStringConvertible, Equatable, Hashable {
    
    public var description: String {
        return string
    }
    
    public static func ==(lhs: MimeType, rhs: MimeType) -> Bool {
        return lhs.string == rhs.string
    }
    
    public var hashValue: Int {
        return string.hashValue
    }
    
}
