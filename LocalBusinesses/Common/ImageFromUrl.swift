//
//  ImageFromUrl.swift
//  LocalBusinesses
//
//  Created by TamNXH on 03/08/2022.
//

import SwiftUI

class ImageFromUrl: ObservableObject {
    @Published var image: UIImage?
    
    private let urlString: String
    private let imageCache = ImageCache.getImageCache()
    
    init(urlString: String) {
        self.urlString = urlString
        loadImage()
    }
    
    private func loadImage() {
        if loadImageFromCache() {
            return
        }
        
        loadImageFromUrl()
    }
    
    private func loadImageFromCache() -> Bool {
        guard let cacheImage = imageCache.get(forKey: urlString) else {
            return false
        }
        
        image = cacheImage
        return true
    }
    
    private func loadImageFromUrl() {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url,
                                              completionHandler: getImageFromResponse(data:response:error:))
        task.resume()
    }
    
    private func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            return
        }
        
        guard let data = data else {
            return
        }
        
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data) else {
                return
            }
            
            self.imageCache.set(forKey: self.urlString, image: loadedImage)
            self.image = loadedImage
        }
    }
}

final class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
