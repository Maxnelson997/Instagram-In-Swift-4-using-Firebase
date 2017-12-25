//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Max Nelson on 12/22/17.
//  Copyright © 2017 AsherApps. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        
        lastURLUsedToLoadImage = urlString
        //nil image removes image swap thats ugly & nasty. && doesnt belong!
        
        self.image = nil
        //first check cache for the image. if cache contains image, we can avoid the url session!
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("failed to fetch post image:", err)
                return
            }
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }

            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            
            //stuff it in cache
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }.resume()
    }
}
