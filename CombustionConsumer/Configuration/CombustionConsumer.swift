//
//  CombustionConsumer.swift
//  CombustionConsumer
//
//  Created by Jonathan Freitas on 30/11/18.
//  Copyright © 2018 Jonathan Freitas. All rights reserved.
//

import Foundation
import Alamofire

public enum Result<T> {
    case success(T)
    case error(String)
}

class CombustionConsumer {
    
    func receiveDataFuncionario (url: String, callback: @escaping (Result<[Funcionario]>) -> Void)  {
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success( _):
                if let data = response.data {
                    let loadedResult = try! JSONDecoder().decode([Funcionario].self, from: data)
                    callback(Result.success(loadedResult))
                }
            case .failure(let error):
                print("Request error: \(error)")
                callback(Result.error("\(error)"))
            }
        }
    }
    
    func receiveDataTimes (url: String, callback: @escaping (Result<[Time]>) -> Void) {
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success( _):
                if let data = response.data {
                    let loadedResult = try! JSONDecoder().decode([Time].self, from: data)
                    callback(Result.success(loadedResult))
                }
            case .failure(let error):
                print("Request error: \(error)")
                callback(Result.error("\(error)"))
            }
        }
    }
}

