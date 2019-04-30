//
//  Router.swift
//  CombustionConsumer
//
//  Created by Jonathan Freitas on 04/12/18.
//  Copyright © 2018 Jonathan Freitas. All rights reserved.
//

import Foundation

protocol RouterShip {
    var name: String { get }
}

enum RouterRoute: RouterShip {
    
    // MARK: - Propeties
    case iOS
    case android
    case frontEnd
    case server
    case design
    case teams
    
    var name: String {
        switch self {
        case .iOS:
            return "workers/ios"
        case .android:
            return "workers/android"
        case.frontEnd:
            return "workers/frontend"
        case .server:
            return "workers/server"
        case.design:
            return "workers/design"
        case .teams:
            return "teams"
        }
    }
}

class RouterRealizer {
    public func endPointConstructor(id: Int) -> String {
        var url = Constants.baseURL
        switch id {
        case 1:
            url += RouterRoute.iOS.name
        case 2:
            url += RouterRoute.android.name
        case 3:
            url += RouterRoute.frontEnd.name
        case 4:
            url += RouterRoute.server.name
        case 5:
            url += RouterRoute.design.name
        default:
            break
        }
        return url
    }
}
