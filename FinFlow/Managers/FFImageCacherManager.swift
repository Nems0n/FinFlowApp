//
//  FFImageCacherManager.swift
//  FinFlow
//
//  Created by Vlad Todorov on 24.04.23.
//

import Foundation
import UIKit

enum FFImageCacherError: Error {
    case wrongURL
    case wrongData
}

final class FFImageCacherManager {
    
    static private let cache = NSCache<NSString, UIImage>()
    
    static public func loadImage(from url: String) async throws -> UIImage {
        
        if let cachedImage = FFImageCacherManager.cache.object(forKey: url as NSString) {
            return cachedImage
        }
        
        guard let imageUrl = URL(string: url) else {
            throw FFImageCacherError.wrongURL
        }
        
        
        let (data, _) = try await URLSession.shared.data(from: imageUrl)
        guard let image = UIImage(data: data) else {
            throw FFImageCacherError.wrongData
        }
        
        FFImageCacherManager.cache.setObject(image, forKey: url as NSString)
        return image
        
    }
    
}
