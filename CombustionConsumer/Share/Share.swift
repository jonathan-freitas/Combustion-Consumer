//
//  ShareInstagram.swift
//  CombustionConsumer
//
//  Created by Jonathan Freitas on 29/04/19.
//  Copyright © 2019 Jonathan Freitas. All rights reserved.
//

import UIKit
import Photos
import Social
import MessageUI
import FBSDKShareKit
import Foundation

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

    /// Shares an image with title and subtitle via Instagram (feed and/or story).
    func toInstagram(image: UIImage, title: String, subtitle: String, completionHandler: ((Bool) -> Void)? = nil) {
        
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
                        if let completion = completionHandler {
                            completion(false)
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        if UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                                    self.delegate?.success()
                                    if let completion = completionHandler {
                                        completion(true)
                                    }
                                })
                            } else {
                                UIApplication.shared.openURL(url)
                                self.delegate?.success()
                                if let completion = completionHandler {
                                    completion(true)
                                }
                                
                            }
                        } else {
                            self.delegate?.error(message: "Instagram not found")
                        }
                    }
                }
            } else if let error = error {
                self.delegate?.error(message: error.localizedDescription)
                if let completion = completionHandler {
                    completion(false)
                }
            }
            else {
                self.delegate?.error(message: "Could not save the photo")
                if let completion = completionHandler {
                    completion(false)
                }
            }
        })
    }
    
    /// Shares a message and link via Facebook
    func toFacebook(viewController: UIViewController, initialText: String, link: URL, completionHandler: ((Bool) -> Void)? = nil) {
        
        // Code for when you don't have FacebookAppID
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            vc.setInitialText(initialText)
            vc.add(link)
            viewController.present(vc, animated: true)
            
            if let completion = completionHandler {
                completion(true)
            }
            
        } else {
            if let completion = completionHandler {
                completion(false)
            }
        }
        
        // Code for when you have a FacebookAppID
//        let linkContent = FBSDKShareLinkContent()
//        linkContent.contentURL = link
//        linkContent.quote = initialText
//
//        let dialog = FBSDKShareDialog()
//        dialog.shareContent = linkContent
//        dialog.shouldFailOnDataError = true
//
//        if dialog.canShow {
//            dialog.show()
//        } else {
//            showError(viewController: viewController, message: "Error on opening Facebook!")
//        }

    }
    
    /// Shares a message and link via Twitter
    func toTwitter(tweetText: String, tweetURL: String, completionHandler: ((Bool) -> Void)? = nil) {
        let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetURL)"
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: escapedShareString)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        if let completion = completionHandler {
            completion(true)
        }
    }
    
    /// Shares a message via WhatsApp
    func toWhatsApp(message: String, completionHandler: ((Bool) -> Void)? = nil) {
        let escapedString = message.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        let url = URL(string: "whatsapp://send?text=\(escapedString!)")
        
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
            if let completion = completionHandler {
                completion(true)
            }
        } else {
            if let completion = completionHandler {
                completion(false)
            }
        }
    }
    
    /// Shares a message and link via Messenger
    func toMessenger(message: String, link: URL, completionHandler: ((Bool) -> Void)? = nil) {
        
        let linkContent = FBSDKShareLinkContent()
        linkContent.contentURL = link
        linkContent.quote = message
    
        let dialog = FBSDKMessageDialog()
        dialog.shareContent = linkContent
        dialog.shouldFailOnDataError = true
        
        if dialog.canShow {
            dialog.show()
            if let completion = completionHandler {
                completion(true)
            }
        } else {
            if let completion = completionHandler {
                completion(false)
            }
        }
        
    }
    
    /// Shares a message and link via Telegram
    func toTelegram(message: String, link: URL, completionHandler: ((Bool) -> Void)? = nil) {
        
        let urlString = "https://telegram.me/share/url?url=\(link)&text=\(message)"
        let tgUrl = URL.init(string:urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if UIApplication.shared.canOpenURL(tgUrl!) {
            UIApplication.shared.open(tgUrl!, options: [:], completionHandler: nil)
            if let completion = completionHandler {
                completion(true)
            }
        } else {
            if let completion = completionHandler {
                completion(false)
            }
        }
        
    }
    
    /// Shares the message and link via iMessage
    func toiMessage(viewController: UIViewController, delegate: MFMessageComposeViewControllerDelegate, message: String, link: URL, completionHandler: ((Bool) -> Void)? = nil) {
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            
            controller.body = "\(message) \(link)"
            controller.recipients = []
            controller.messageComposeDelegate = delegate
            
            viewController.present(controller, animated: true, completion: nil)
            
            if let completion = completionHandler {
                completion(true)
            }
        } else {
            if let completion = completionHandler {
                completion(false)
            }
        }
        
    }
    
    /// Shows a modal with other alternatives of social media.
    func toOthers(viewController: UIViewController, text: String?, image: UIImage?, completionHandler: ((Bool) -> Void)? = nil) {
        
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
            activityViewController.title = "Share"
            
            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop,
                                                            UIActivity.ActivityType.postToWeibo,
                                                            UIActivity.ActivityType.print,
                                                            UIActivity.ActivityType.assignToContact,
                                                            UIActivity.ActivityType.saveToCameraRoll,
                                                            UIActivity.ActivityType.addToReadingList,
                                                            UIActivity.ActivityType.postToFlickr,
                                                            UIActivity.ActivityType.postToVimeo,
                                                            UIActivity.ActivityType.postToTencentWeibo]
            
            viewController.present(activityViewController, animated: true, completion: nil)
            
            if let completion = completionHandler {
                completion(true)
            }
        } else {
            if let completion = completionHandler {
                completion(false)
            }
        }
    }
    
    /// Simple function to copy a text to the clipboard.
    func copyToClipboard(text: String, completionHandler: ((Bool) -> Void)? = nil) {
        UIPasteboard.general.string = text
        
        if UIPasteboard.general.string == text {
            if let completion = completionHandler {
                completion(true)
            }
        } else {
            if let completion = completionHandler {
                completion(false)
            }
        }
    }
}
