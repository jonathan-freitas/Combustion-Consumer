//
//  ShowDetailsController.swift
//  CombustionConsumer
//
//  Created by Jonathan Freitas on 03/12/18.
//  Copyright © 2018 Jonathan Freitas. All rights reserved.
//

import UIKit
import MessageUI
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
            share.toInstagram(image: image, title: funcionario!.nome, subtitle: funcionario!.funcao)
        case 1:
            share.toFacebook(viewController: self, initialText: funcionario!.nome, link: URL(string: "https://www.apple.com")!)
        case 2:
            share.toTwitter(tweetText: funcionario!.nome, tweetURL: "https://www.apple.com")
        case 3:
            share.toWhatsApp(message: "Look: \(funcionario!.nome)! https://www.apple.com")
        case 5:
            share.toMessenger(message: "Look!", link: URL(string: "https://www.apple.com")!)
        case 6:
            share.toTelegram(message: "Look!", link: URL(string: "https://www.apple.com")!)
        case 7:
            share.toiMessage(viewController: self, delegate: self, message: "Look!", link: URL(string: "https://www.apple.com")!)
        case 8:
            share.copyToClipboard(text: "Louco!", completionHandler: { result in
                
                let alert = UIAlertController(title:   result ? "Captions copied"                           : "Captions error",
                                              message: result ? "The captions was copied to the clipboard." : "There was an error on copying the captions.",
                                              preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
                
            })
        case 9:
            share.toOthers(viewController: self, text: nil, image: image)
        default:
            break
        }

    }
}

extension ShowDetailsController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
