//
//  StnCacheable.swift
//  StnPhotoBrowser
//
//

import UIKit.UIImage

public protocol StnCacheable {}
public protocol StnImageCacheable: StnCacheable {
    func imageForKey(_ key: String) -> UIImage?
    func setImage(_ image: UIImage, forKey key: String)
    func removeImageForKey(_ key: String)
}

public protocol StnRequestResponseCacheable: StnCacheable {
    func cachedResponseForRequest(_ request: URLRequest) -> CachedURLResponse?
    func storeCachedResponse(_ cachedResponse: CachedURLResponse, forRequest request: URLRequest)
}
