//
//  Router.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 15/7/2024.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
    public enum Destination: Codable, Hashable {
        case newQuote
        case existing
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
