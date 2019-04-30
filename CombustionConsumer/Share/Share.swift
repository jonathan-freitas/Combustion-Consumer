//
//  ShareInstagram.swift
//  CombustionConsumer
//
//  Created by Jonathan Freitas on 29/04/19.
//  Copyright © 2019 Jonathan Freitas. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Social

public protocol ShareStoriesDelegate {
    func error(message: String)
    func success()
}

class Share {
    
    // Instagram
    private let instagramURL = URL(string: "instagram://app")
    private let instagramStoriesURL = URL(string: "instagram-stories://share")
    private let deepLink = "www.bosta.com"
    
    private let waterMark = UIImage(named: "icWatermark")!.resizeImage(targetSize: CGSize(width: 652, height: 80))
    
    var delegate: ShareStoriesDelegate?
    
    public init() {}

    func toInstagram(image: UIImage, title: String, subtitle: String, captions: String?) {
        
        if let captions = captions {
            UIPasteboard.general.string = captions
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: UIImageLibraries.returnImageToShare(waterMark: self.waterMark, image: image, title: title, subtitle: subtitle))
        }, completionHandler: { success, error in
            if success {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                if let lastAsset = fetchResult.firstObject {
                    let localIdentifier = lastAsset.localIdentifier
                    let urlFeed = "instagram://library?LocalIdentifier=" + localIdentifier
                    guard let url = URL(string: urlFeed) else {
                        self.delegate?.error(message: "Could not open url")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        if UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                                    self.delegate?.success()
                                })
                            } else {
                                UIApplication.shared.openURL(url)
                                self.delegate?.success()
                                
                            }
                        } else {
                            self.delegate?.error(message: "Instagram not found")
                        }
                    }
                }
            } else if let error = error {
                self.delegate?.error(message: error.localizedDescription)
            }
            else {
                self.delegate?.error(message: "Could not save the photo")
            }
        })
    }
    
    func toFacebook(viewController: UIViewController, initialText: String, link: URL) {
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            vc.setInitialText(initialText)
            vc.add(link)
            viewController.present(vc, animated: true)
        }
    }
    
    func toTwitter(tweetText: String, tweetURL: String) {
        let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetURL)"
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: escapedShareString)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func toWhatsApp(message: String) {
        let escapedString = message.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        let url = URL(string: "whatsapp://send?text=\(escapedString!)")
        
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        } else {
            print("Error on sharing in WhatsApp! App not installed!")
        }
    }
    
    func toOthers(viewController: UIViewController, text: String?, image: UIImage?) {
        
        var objectsToShare = [AnyObject]()
        
        if let image = image {
            objectsToShare.append(image)
        }
        
        if let text = text {
            objectsToShare.append(text as AnyObject)
        }
        
        if objectsToShare.count > 0 {
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = viewController.view
            
            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
            
            viewController.present(activityViewController, animated: true, completion: nil)
        } else {
            print("Error on sharing in others! Neither text or image was found!")
        }
    }
    
//    func postToInstagramStories(data: NSData, image: UIImage) {
//
//        let colors = image.getColors()
//
//        DispatchQueue.main.async {
//
//            guard let url = self.instagramURL else {
//                self.delegate?.error(message: "URL not valid")
//                return
//            }
//
//            if UIApplication.shared.canOpenURL(url) {
//
//                guard let urlScheme = self.instagramStoriesURL else {
//                    self.delegate?.error(message: "URL not valid")
//                    return
//                }
//
//                let pasteboardItems = ["com.instagram.sharedSticker.stickerImage": image,
//                                       "com.instagram.sharedSticker.backgroundTopColor" : colors.primary.toHexString(),
//                                       "com.instagram.sharedSticker.backgroundBottomColor" : colors.primary.toHexString(),
//                                       "com.instagram.sharedSticker.backgroundVideo": data,
//                                       "com.instagram.sharedSticker.contentURL": self.deepLink] as [String : Any]
//
//                if #available(iOS 10.0, *) {
//                    let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate : NSDate().addingTimeInterval(60 * 5)]
//                    UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
//
//                } else {
//                    UIPasteboard.general.items = [pasteboardItems]
//                }
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(urlScheme, options: [:], completionHandler: { (success) in
//                        self.delegate?.success()
//                    })
//                } else {
//                    UIApplication.shared.openURL(urlScheme)
//                    self.delegate?.success()
//                }
//
//            } else {
//                self.delegate?.error(message: "Could not open instagram URL. Check if you have instagram installed and you configured your LSApplicationQueriesSchemes to enable instagram's url")
//            }
//        }
//    }
    
}
