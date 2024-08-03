//
//  AppRootManager.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 1/8/2024.
//

import Foundation

class AppRootManager: ObservableObject {
    
    @Published var currentRoot: eAppRoots = .splash
    
    func loadUser() -> eAppRoots {
        if UserDefaults.standard.data(forKey: "user") != nil {
            return .main
        }
        return .authentication
    }
    
    enum eAppRoots {
        case splash
        case authentication
        case main
    }
}
