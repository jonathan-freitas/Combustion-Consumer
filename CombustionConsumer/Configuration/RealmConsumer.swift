//
//  RealmConsumer.swift
//  CombustionConsumer
//
//  Created by Jonathan Freitas on 05/12/18.
//  Copyright © 2018 Jonathan Freitas. All rights reserved.
//

import Foundation
import RealmSwift

class FuncionarioRealm: Object {
    
    // MARK: - Properties
    @objc dynamic var id: Int = 0
    @objc dynamic var team: Int = 0
    @objc dynamic var nome: String = ""
    @objc dynamic var idade: Int = 0
    @objc dynamic var funcao: String = ""
    @objc dynamic var img: String = ""

}

class RealmConsumer {
    let realm = try! Realm()
    
    private func funcionarioToRealm(funcionarios: [Funcionario]) -> [FuncionarioRealm] {
        var funcionarioBosta = [FuncionarioRealm]()
        for element in funcionarios {
            let funcionarioAux = FuncionarioRealm()
            
            funcionarioAux.id = element.id
            funcionarioAux.team = element.team
            funcionarioAux.nome = element.nome
            funcionarioAux.idade = element.idade
            funcionarioAux.funcao = element.funcao
            funcionarioAux.img = element.img
            
            funcionarioBosta.append(funcionarioAux)
        }
        return funcionarioBosta
    }
    
    private func realmToFuncionario(funcionarios: [FuncionarioRealm]) -> [Funcionario] {
        var funcionarioBosta = [Funcionario]()
        for element in funcionarios {
            let funcionarioAux = Funcionario(id: element.id, team: element.team, nome: element.nome, idade: element.idade, funcao: element.funcao, img: element.img)
            funcionarioBosta.append(funcionarioAux)
        }
        return funcionarioBosta
    }
    
    public func realmAdd(funcionarios: [Funcionario]) {
        let funcionarioBosta = funcionarioToRealm(funcionarios: funcionarios)
        
        if realmCheck(teamID: funcionarioBosta[0].team) == true { // Exists
            for element in funcionarioBosta {
                let myFuncionario = realm.objects(FuncionarioRealm.self).filter("id == \(element.id)").first
                try! realm.write {
                    myFuncionario!.funcao = element.funcao
                    myFuncionario!.nome = element.nome
                    myFuncionario!.idade = element.idade
                    myFuncionario!.img = element.img
                    myFuncionario!.team = element.team
                }
            }
        } else { // Don't exist
            for element in funcionarioBosta {
                try! realm.write {
                    realm.add(element)
                }
            }
        }
    }
    
    public func realmCheck(teamID: Int) -> Bool {
        if realm.objects(FuncionarioRealm.self).count > 0 {
            if (realm.objects(FuncionarioRealm.self).filter("team == \(teamID)").count > 0){
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    public func realmRetrieve(teamID: Int) -> [Funcionario] {
        var funcionarios = [FuncionarioRealm]()
        let objects = realm.objects(FuncionarioRealm.self).filter("team == \(teamID)")
        print(objects[0].id)
        
        let array = Array(objects)
        for element in array {
            funcionarios.append(element)
        }
        return realmToFuncionario(funcionarios: funcionarios)
    }
}
