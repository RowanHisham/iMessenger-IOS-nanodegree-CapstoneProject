//
//  UIImageViewExtension.swift
//  iMessenger
//
//  Created by Rowan Hisham on 4/30/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView{
    func loadImageUsingCacheWithURLString(url: String){
        
        //Get Image from Cache
        if let cachedImage = imageCache.object(forKey: url as NSString){
            self.image = cachedImage
        }
        // Download Profile Picture
        FirebaseClient.downloadImage(imageURL: url){ data, error in
            guard error == nil, data != nil else{
                DispatchQueue.main.async {
                    self.image = #imageLiteral(resourceName: "profilePicturePlaceholder")
                }
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: url as NSString)
                    self.image = downloadedImage
                }
            }
        }
    }
}
