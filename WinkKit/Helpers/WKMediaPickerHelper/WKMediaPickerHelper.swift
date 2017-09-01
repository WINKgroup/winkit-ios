//
//  WKMediaPickerHelper.swift
//  CityNews
//
//  Created by Rico Crescenzio on 05/12/16.
//  Copyright © 2016 Wink. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

/// The media type that could be picked.
///
/// SeeAlso: `WKMediaPickerHelper`
///
public enum WKMediaType {
    
    // MARK: - Cases
    
    case image
    case video
    
    // MARK: - Computed Properties
    
    /// Return the `UTType` based on the case of `self`.
    /// if `self == .image` return `kUTTypeImage` otherwise return `kUTTypeMovie`.
    public var uTType: String {
        switch self {
        case .image:
            return kUTTypeImage as String
        case .video:
            return kUTTypeMovie as String
        }
    }

}

/// Picker result in the callback closure.
public enum WKPickerResult {
    
    /// The `WKMediaImage` has been picked correctly.
    case pickedImage(WKMediaImage)
    
    /// The `WKMediaVideo` has been picked correctly.
    case pickedVideo(WKMediaVideo)
    
    /// The compressed media is still too big than the maxSize specified.
    case fileSizeExceeded(WKMediaType, Int64)
    
    /// The user cancelled the picking of the `WKMedia`.
    case cancelled
    
    /// Some unknown error occurred.
    case failure
}

/// The mimimum value that a picture must have to be processed
let minimumAllowedQualitySize = CGFloat(0.3)

/// The enum result of the image/video compression
fileprivate enum WKProcessResult<T: WKMedia> {
    case success(T)
    case sizeExceeded(Int64)
    case failure
}

/// Picker callback is the closure called when a media has been picked, or the coperation has been canceled or some error happened.
public typealias WKPickerCallback = (WKPickerResult)->Void

/// This class is used to make the picking of a media (image/video) simpler.
/// Simply instantiate the picker and call the method `pick(mediaTypes:from:in:completion)`.
///
/// - Important: Don't forget to retain the picker, by adding it as an instance variable, otherwise
///              the completion won't be called.
///
/// A tipical usage could be:
///
///     picker.pick(mediaTypes: [.image, .video], from: .photoLibrary, in: self) { result in
///         switch result {
///         case .pickedImage(let media):
///             print(media.name)
///         
///         case .pickedVideo(let media):
///             print(media.name)
///
///         case .fileSizeExceeded(let mediaType, let maxSize):
///             print("Max size exceeded: \(maxSize)")
///
///         default:
///             break
///         }
///     }
///
open class WKMediaPickerHelper: NSObject {
    
    // MARK: - Properties
    
    fileprivate let imagePicker = UIImagePickerController()
    fileprivate var completion: WKPickerCallback!
    fileprivate var activityIndicator: UIActivityIndicatorView!
    
    /// The max byte number for the compressed image, for example if it's 4194303
    /// the max size of image will be 4MB; if `nil`, no max size will be applied.
    open var imageMaxByte: Int64?
    
    /// The max byte number for the compressed video, for example if it's 134217727,
    /// the max size of video will be 128MB; if `nil`, no max size will be applied.
    open var videoMaxByte: Int64?
    
    /// The video quality. Default is `.typeIFrame1280x720`.
    public var videoQuality: UIImagePickerControllerQualityType = .typeIFrame1280x720 {
        didSet {
            imagePicker.videoQuality = videoQuality
        }
    }
    
    /// Tells the picker if the editing of the media is possible. Default is false.
    public var allowsEditing: Bool = false {
        didSet {
            imagePicker.allowsEditing = allowsEditing
        }
    }
    
    // MARK: - Initializers
    
    public init(imageMaxByte: Int64? = nil, videoMaxByte: Int64? = nil, allowsEditing: Bool = false, videoQuality: UIImagePickerControllerQualityType = .typeIFrame1280x720) {
        super.init()
        imagePicker.delegate = self
        imagePicker.videoQuality = videoQuality
        
        self.allowsEditing = allowsEditing
        self.imageMaxByte = imageMaxByte
        self.videoMaxByte = videoMaxByte
        self.videoQuality = videoQuality
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.hidesWhenStopped = true
        
        imagePicker.view.addSubview(activityIndicator)
        activityIndicator.center = imagePicker.view.center
    }
    
    // MARK: - Methods
    
    /// Pick the media. You can specify different options of picking.
    ///
    /// - Parameters: 
    ///     - mediaTypes: A `Set` of `WKMediaType` to specify what kind of media are pickable. 
    ///                   Default takes both image and videos.
    ///     - sourceType: Specify from where the media will be picked. See `UIImagePickerControllerSourceType`.
    ///     - viewController: The `UIViewController` that open the picker.
    ///     - completion: The closure of the picking completion.
    open func pick(mediaTypes: Set<WKMediaType> = [.image, .video], from sourceType: UIImagePickerControllerSourceType, in viewController: UIViewController, completion: @escaping WKPickerCallback) {
        imagePicker.sourceType = sourceType
        mediaTypes.forEach() { mediaType in
            self.imagePicker.mediaTypes.append(mediaType.uTType)
        }
        self.completion = completion
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    fileprivate func processImage(image: UIImage, completion: @escaping (WKProcessResult<WKMediaImage>)->Void) {
        let processImageQueue = DispatchQueue(label: "by.wink.WinkKit.process_image_queue", attributes: .concurrent)
        processImageQueue.async {
            var quality = CGFloat(1)
            if let data = UIImageJPEGRepresentation(image, quality) {
                var data = data
                if let maxImageSize = self.imageMaxByte {
                    while Int64(data.count) > maxImageSize {
                        if quality < minimumAllowedQualitySize {
                            completion(.sizeExceeded(maxImageSize))
                            return
                        }
                        quality -= 0.1
                        data = UIImageJPEGRepresentation(image, quality)!
                    }
                }
                let compressedUiImage = UIImage(data: data)!
                completion(.success(WKMediaImage(name: UUID().uuidString, image: compressedUiImage, jpegCompressedData: data, quality: quality)))
                
            } else {
                completion(.failure)
            }
            
        }
    }
    
    fileprivate func processVideo(inputURL: URL, with thumb: UIImage) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            return
        }
        exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, urlAsset.duration) //needed to know the estimate final size
        let uuid = NSUUID().uuidString
        exportSession.outputURL = URL(fileURLWithPath: NSTemporaryDirectory() + uuid + ".mp4")
        exportSession.outputFileType = .mp4
        exportSession.shouldOptimizeForNetworkUse = true
        
        if let maxSize = self.videoMaxByte, exportSession.estimatedOutputFileLength >= maxSize {
            endProcessing(with: .fileSizeExceeded(.video, maxSize))
            return
        }
        
        exportSession.exportAsynchronously { [weak self] in
            guard let aliveSelf = self else { return }
            
            switch exportSession.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = try? Data(contentsOf: exportSession.outputURL!) else { return }
                
                if let maxSize = aliveSelf.videoMaxByte, Int64(compressedData.count) >= maxSize {
                    aliveSelf.endProcessing(with: .fileSizeExceeded(.video, maxSize))
                } else {
                    let video = WKMediaVideo(name: uuid, url: exportSession.outputURL!, thumbnail: thumb)
                    aliveSelf.endProcessing(with: .pickedVideo(video))
                }
            case .failed:
                aliveSelf.endProcessing(with: .failure)
                
            case .cancelled:
                aliveSelf.endProcessing(with: .cancelled)
            }
        }
        
    }
    
    fileprivate func endProcessing(with result: WKPickerResult) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.imagePicker.dismiss(animated: true) {
                self.completion(result)
            }
        }
    }
}

extension WKMediaPickerHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == WKMediaType.image.uTType as String {
            let uiImage = info[UIImagePickerControllerEditedImage] as! UIImage
            activityIndicator.startAnimating()
            processImage(image: uiImage) { [weak self] result in
                guard let aliveSelf = self else { return }
                
                var pickerResult: WKPickerResult!
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        pickerResult = .pickedImage(image)
                        
                    case .sizeExceeded(let maxSize):
                        pickerResult = .fileSizeExceeded(.image, maxSize)
                        
                    case .failure:
                        pickerResult = .failure
                    }
                    aliveSelf.activityIndicator.stopAnimating()
                    aliveSelf.endProcessing(with: pickerResult)
                }
                
            }
            
        } else if mediaType == WKMediaType.video.uTType as String {
            let url = info[UIImagePickerControllerMediaURL] as! URL
            let asset = AVURLAsset(url: url, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true // to get the correct orientation
            let cgImage = try? imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            
            if let image = cgImage {
                let thumb = UIImage(cgImage: image)
                activityIndicator.startAnimating()
                processVideo(inputURL: url as URL, with: thumb)
            } else {
                endProcessing(with: .failure)
            }
            
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true) { [unowned self] in
            self.completion(.cancelled)
        }
    }
}
