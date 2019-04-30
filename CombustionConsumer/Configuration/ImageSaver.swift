//
//  ImageSaver.swift
//  CombustionConsumer
//
//  Created by Jonathan Freitas on 06/12/18.
//  Copyright © 2018 Jonathan Freitas. All rights reserved.
//

import UIKit

class ImageSaver {
    let directoryFolderPath = "/Teams/"
    
    func createFolder() {
        if let direct = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = direct.appendingPathComponent(directoryFolderPath)
            if !FileManager.default.fileExists(atPath: filePath.path) {
                do {
                    try FileManager.default.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    NSLog("Coudn't create document directory!")
                }
            }
        }
    }
    
    func setSavedImage(image: UIImage, imageName: String) -> Bool {
        createFolder()
        
        let name = imageName + ".png"
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(directoryFolderPath + name)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getSavedImage(imageName: String) -> UIImage? {
        createFolder()
        
        let name = imageName + ".png"
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(directoryFolderPath + name).path)!
        }
        return nil
    }
    
    func checkSavedImage(imageName: String) -> Bool {
        createFolder()
        
        let name = imageName + ".png"
        let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        if UIImage(contentsOfFile: URL(fileURLWithPath: dir!.absoluteString).appendingPathComponent(directoryFolderPath + name).path) != nil {
            return true
        }
        return false
    }

}
