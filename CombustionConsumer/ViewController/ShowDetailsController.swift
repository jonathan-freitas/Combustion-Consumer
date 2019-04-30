//
//  ShowDetailsController.swift
//  CombustionConsumer
//
//  Created by Jonathan Freitas on 03/12/18.
//  Copyright © 2018 Jonathan Freitas. All rights reserved.
//

import UIKit
import AlamofireImage

class ShowDetailsController: UIViewController {
    
    // MARK: - Properties
    var funcionario: Funcionario?
    var time: Time?
    
    @IBOutlet weak var labelID: UILabel!
    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var labelIdade: UILabel!
    @IBOutlet weak var labelTeam: UILabel!
    @IBOutlet weak var labelFuncao: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    private let share = Share()
    
    override func viewDidLoad() {
        
        self.navigationItem.title = funcionario?.nome
        labelID.text = String(funcionario!.id)
        labelNome.text = funcionario?.nome
        labelIdade.text = "\(String(funcionario!.idade)) anos"
        labelTeam.text = time?.nome
        labelFuncao.text = funcionario?.funcao
        imgView.af_setImage(withURL: URL(string: (funcionario?.img)!)!, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: true) { (response) in }
    }
    
    @IBAction func share(_ sender: UIButton) {
        
        let image = imgView.image!
        
        switch sender.tag {
        case 0:
            share.toInstagram(image: image, title: funcionario!.nome, subtitle: funcionario!.funcao, captions: nil)
        case 1:
            share.toFacebook(viewController: self, initialText: funcionario!.nome, link: URL(string: "www.google.com")!)
        case 2:
            share.toTwitter(tweetText: funcionario!.nome, tweetURL: "www.google.com")
        case 3:
            share.toWhatsApp(message: "Look: \(funcionario!.nome)! www.google.com")
        case 4:
            share.toOthers(viewController: self, text: nil, image: image)
        default:
            break
        }
    
    }
}

