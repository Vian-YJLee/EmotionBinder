//
//  ImageExtension.swift
//  EmotionBinder
//
//  Created by LeeYongJin on 2019/08/20.
//  Copyright © 2019 vian. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        
        let size = self.size
        
        let widthRatio = targetSize.width / self.size.width
        let heihgtRatio = targetSize.height / self.size.height
        
        // Figure out What our orientation is, and use that to rorm the rectangle
        
        var newSize: CGSize
        if(widthRatio > heihgtRatio) {
            newSize = CGSize(width: size.width * heihgtRatio, height: size.height * heihgtRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        //This is the rect that we've calculated out and this is what is actually use below
        
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        
        
        //Actually do the resizing to the rect using the ImageContext stuff
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
}
