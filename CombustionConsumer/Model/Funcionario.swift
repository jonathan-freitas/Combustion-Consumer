//
//  Funcionario.swift
//  CombustionConsumer
//
//  Created by Jonathan Freitas on 30/11/18.
//  Copyright © 2018 Jonathan Freitas. All rights reserved.
//
              
import Foundation
import RealmSwift

class Funcionario: Decodable {
    
    // MARK: - Properties
    var id: Int
    var team: Int
    var nome: String
    var idade: Int
    var funcao: String
    var img: String

    init(id: Int, team: Int, nome: String, idade: Int, funcao: String, img: String) {
        self.id = id
        self.team = team
        self.nome = nome
        self.idade = idade
        self.funcao = funcao
        self.img = img
    }
}
