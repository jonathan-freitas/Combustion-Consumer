//
//  UIImage+Extension'.swift
//  CombustionConsumer
//
//  Created by Jonathan Freitas on 29/04/19.
//  Copyright © 2019 Jonathan Freitas. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func textToImage(title: String, subtitle: String, point: CGPoint, fontSize: CGFloat, titleFont: UIFont, subtitleFont: UIFont) -> UIImage {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        
        let fontTitle = titleFont.withSize(fontSize) 
        let fontSubtitle = subtitleFont.withSize(fontSize)
        
        let textFontAttributesTitle = [NSAttributedString.Key.font: fontTitle,
                                       NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: textStyle]
        
        
        
        
        let textFontAttributesSubtitle = [NSAttributedString.Key.font: fontSubtitle,
                                          NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: textStyle]
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        
        let pointText = CGPoint(x: 0, y: self.size.height - point.y)
        
        title.draw(in: CGRect(origin: pointText, size: self.size), withAttributes: textFontAttributesTitle)
        
        if title.count < 35 {
            subtitle.draw(in: CGRect(origin: CGPoint.init(x: pointText.x, y: pointText.y + fontTitle.lineHeight + 8), size: self.size), withAttributes: textFontAttributesSubtitle)
        } else {
            subtitle.draw(in: CGRect(origin: CGPoint.init(x: pointText.x, y: pointText.y + fontTitle.lineHeight + 56), size: self.size), withAttributes: textFontAttributesSubtitle)
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
        
    }
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
