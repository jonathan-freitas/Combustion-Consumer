//
//  WorkersTableViewCell.swift
//  CombustionConsumer
//
//  Created by Jonathan Freitas on 04/12/18.
//  Copyright © 2018 Jonathan Freitas. All rights reserved.
//

import UIKit

class WorkersTableViewCell: UITableViewCell {

    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var labelFuncao: UILabel!
    @IBOutlet weak var labelID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    public func configuration(funcionario: Funcionario) {
        labelID.text = String(funcionario.id)
        labelNome.text = funcionario.nome
        labelFuncao.text = funcionario.funcao
    }
}
