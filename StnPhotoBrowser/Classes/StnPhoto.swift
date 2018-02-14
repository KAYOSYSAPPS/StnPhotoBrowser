//
//  StnPhoto.swift
//  StnViewExample
//
//

import UIKit

@objc public protocol StnPhotoProtocol: NSObjectProtocol {
    var underlyingImage: UIImage! { get }
    var caption: String! { get }
    var index: Int { get set}
    var contentMode: UIViewContentMode { get set }
    func loadUnderlyingImageAndNotify()
    func checkCache()
}

// MARK: - StnPhoto
open class StnPhoto: NSObject, StnPhotoProtocol {
    
    open var underlyingImage: UIImage!
    open var photoURL: String!
    open var contentMode: UIViewContentMode = .scaleAspectFill
    open var shouldCachePhotoURLImage: Bool = false
    open var caption: String!
    open var index: Int = 0

    override init() {
        super.init()
    }
    
    convenience init(image: UIImage) {
        self.init()
        underlyingImage = image
    }
    
    convenience init(url: String) {
        self.init()
        photoURL = url
    }
    
    convenience init(url: String, holder: UIImage?) {
        self.init()
        photoURL = url
        underlyingImage = holder
    }
    
    open func checkCache() {
        guard let photoURL = photoURL else {
            return
        }
        guard shouldCachePhotoURLImage else {
            return
        }
        
        if StnCache.sharedCache.imageCache is StnRequestResponseCacheable {
            let request = URLRequest(url: URL(string: photoURL)!)
            if let img = StnCache.sharedCache.imageForRequest(request) {
                underlyingImage = img
            }
        } else {
            if let img = StnCache.sharedCache.imageForKey(photoURL) {
                underlyingImage = img
            }
        }
    }
    
    open func loadUnderlyingImageAndNotify() {
        
        if underlyingImage != nil {
            loadUnderlyingImageComplete()
            return
        }
        
        if photoURL != nil {
            // Fetch Image
            let session = URLSession(configuration: URLSessionConfiguration.default)
            if let nsURL = URL(string: photoURL) {
                var task: URLSessionDataTask!
                task = session.dataTask(with: nsURL, completionHandler: { [weak self] (data, response, error) in
                    if let _self = self {
                        
                        if error != nil {
                            DispatchQueue.main.async {
                                _self.loadUnderlyingImageComplete()
                            }
                        }
                        
                        if let data = data, let response = response, let image = UIImage(data: data) {
                            if _self.shouldCachePhotoURLImage {
                                if StnCache.sharedCache.imageCache is StnRequestResponseCacheable {
                                    StnCache.sharedCache.setImageData(data, response: response, request: task.originalRequest!)
                                } else {
                                    StnCache.sharedCache.setImage(image, forKey: _self.photoURL)
                                }
                            }
                            DispatchQueue.main.async {
                                _self.underlyingImage = image
                                _self.loadUnderlyingImageComplete()
                            }
                        }
                        session.finishTasksAndInvalidate()
                    }
                })
                task.resume()
            }
        }
    }

    open func loadUnderlyingImageComplete() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: StnPHOTO_LOADING_DID_END_NOTIFICATION), object: self)
    }
    
}

// MARK: - Static Function

extension StnPhoto {
    public static func photoWithImage(_ image: UIImage) -> StnPhoto {
        return StnPhoto(image: image)
    }
    
    public static func photoWithImageURL(_ url: String) -> StnPhoto {
        return StnPhoto(url: url)
    }
    
    public static func photoWithImageURL(_ url: String, holder: UIImage?) -> StnPhoto {
        return StnPhoto(url: url, holder: holder)
    }
}
