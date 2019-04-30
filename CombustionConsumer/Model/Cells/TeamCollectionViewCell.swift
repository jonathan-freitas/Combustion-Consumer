//
//  TeamCollectionViewCell.swift
//  CombustionConsumer
//
//  Created by Jonathan Freitas on 04/12/18.
//  Copyright © 2018 Jonathan Freitas. All rights reserved.
//

import UIKit
import AlamofireImage

class TeamCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configuration(team: Time) {
        if ImageSaver().checkSavedImage(imageName: (team.nome)) == true {
            image.image = ImageSaver().getSavedImage(imageName: (team.nome))
        } else {
            image!.af_setImage(withURL: URL(string: team.img)!, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: true) { (response) in
                response.result.ifSuccess {
                    if ImageSaver().setSavedImage(image: self.image.image!, imageName: (team.nome)) {
                        print("Saved Image sucessfully!")
                    } else {
                        print("Error on saving the Image!")
                    }
                }
            }
        }
    }
}
