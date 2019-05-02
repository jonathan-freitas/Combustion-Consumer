//
//  ViewController.swift
//  CombustionConsumer
//
//  Created by Jonathan Freitas on 30/11/18.
//  Copyright © 2018 Jonathan Freitas. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class ViewController: UITableViewController {
    
    // MARK: - Properties
    var funcionarios = [Funcionario]()
    var team: Time?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        receiveTableViewData()
        
        self.navigationItem.title = team?.nome
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 60
        self.tableView.register(UINib(nibName: "WorkersTableViewCell", bundle: nil), forCellReuseIdentifier: "WorkersTableViewCell")
    }
    
    private func receiveTableViewData() {
        if RealmConsumer().realmCheck(teamID: self.team!.id) == true {
            self.funcionarios = RealmConsumer().realmRetrieve(teamID: team!.id)
        } else {
            let url = RouterRealizer().endPointConstructor(id: (team?.id)!)
            
            CombustionConsumer().receiveDataFuncionario(url: url){ callback in
                switch callback {
                case .success(let arrayFuncionario):
                    self.funcionarios = arrayFuncionario
                    RealmConsumer().realmAdd(funcionarios: self.funcionarios)
                    break
                case .error(let errorMessage):
                    print("Error message: \(errorMessage)")
                    break
                }
            }
        }
        
        bindTableView()
    }
    
    private func bindTableView() {
        
        tableView.dataSource = nil
        let funcObservable = Observable.just(self.funcionarios)
        
        funcObservable.bind(to: self.tableView.rx.items) { (tableView, row, object) in
            let indexPath = IndexPath(row: row, section: 0)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkersTableViewCell", for: indexPath) as! WorkersTableViewCell
            cell.configuration(funcionario: object)
            
            return cell
        }
        .disposed(by: self.disposeBag)
        
        tableView.rx.itemSelected.asDriver()
            .do(onNext: { indexPath in
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "ShowDetailsViewController") as! ShowDetailsController
                newViewController.funcionario = self.funcionarios[indexPath.row]
                newViewController.time = self.team
                self.navigationController?.pushViewController(newViewController, animated: true)
        })
        .drive()
        .disposed(by: disposeBag)
        
    }
}
