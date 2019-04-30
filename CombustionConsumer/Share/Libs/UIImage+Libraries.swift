//
//  StichImages.swift
//  CombustionConsumer
//
//  Created by Jonathan Freitas on 29/04/19.
//  Copyright © 2019 Jonathan Freitas. All rights reserved.
//

import UIKit

struct UIImageLibraries {
    
    static func returnImageToShare(waterMark: UIImage, image: UIImage, title: String, subtitle: String) -> UIImage {
        
        // Getting the colors from the received image
        let colors = image.getColors()
        
        // Resizing the received image and the text image
        let imageResized = image.resizeImage(targetSize: CGSize(width: 652, height: 652))
        let textResized = UIImage(color: .clear, size: CGSize(width: 652, height: 88))!.textToImage(title: title, subtitle: subtitle, point: CGPoint(x: 0, y: 230), fontSize: 100, titleFont: UIFont.systemFont(ofSize: 100), subtitleFont: UIFont.systemFont(ofSize: 100)).resizeImage(targetSize: CGSize(width: 652, height: 88))
        
        // The array containing all necessary images to stitch
        let imageArray = [waterMark, imageResized, textResized]
        
        // The background image with a gradient of the primary and secondary colors
        let imageBackground = UIImage(color: .clear, size: CGSize(width: 1080, height: 1920))!.resizeImage(targetSize: CGSize(width: 1080, height: 1920))
        let imageBackgroundGradient = UIImageLibraries.placeGradientInImage(img: imageBackground, colors: [colors.primary.cgColor, colors.secondary.cgColor])
        
        // The stitched image containing all images combined
        let stickerImage = UIImageLibraries.stitchImages(images: imageArray, isVertical: true)
        
        return UIImageLibraries.overlayImages(bottomImage: imageBackgroundGradient, topImage: stickerImage)
    }
    
    
    static func stitchImages(images: [UIImage], isVertical: Bool) -> UIImage {
        
        var maxHeight: CGFloat = 0.0
        var maxWidth: CGFloat = 0.0
        
        for image in images {
            maxHeight += image.size.height + 8
            if image.size.width > maxWidth {
                maxWidth = image.size.width
            }
        }
        
        let finalSize = CGSize(width: maxWidth, height: maxHeight)
        
        UIGraphicsBeginImageContext(finalSize)
        
        var runningHeight: CGFloat = 0.0
        
        for image in images {
            image.draw(in: CGRect(x: 0.0, y: runningHeight, width: image.size.width, height: image.size.height))
            runningHeight += image.size.height + 8
        }
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
    
    static func overlayImages(bottomImage: UIImage, topImage: UIImage) -> UIImage {
        
        let newSize = CGSize(width: 1080, height: 1920)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        bottomImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        topImage.draw(in: CGRect(origin: CGPoint(x: bottomImage.size.width / 5, y: bottomImage.size.height / 4), size: topImage.size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    static func placeGradientInImage(img: UIImage!, colors: [CGColor]) -> UIImage {
        
        UIGraphicsBeginImageContext(img.size)
        let context = UIGraphicsGetCurrentContext()
        
        img.draw(at: CGPoint(x: 0, y: 0))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]
        let colors = colors as CFArray
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        
        let startPoint = CGPoint(x: img.size.width/2, y: 0)
        let endPoint = CGPoint(x: img.size.width/2, y: img.size.height)
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
}
