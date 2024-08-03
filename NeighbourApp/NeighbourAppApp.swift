//
//  NeighbourAppApp.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 14/7/2024.
//

import SwiftUI
import FirebaseCore

@main
struct NeighbourAppApp: App {
    @StateObject var appRootManager = AppRootManager()
    var router = Router()
    var base = Base()
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot {
                case .splash:
                    SplashView()
                case .authentication:
                    AuthView()
                case .main:
                    ContentView().environmentObject(router).environmentObject(base)
                }
            }
            .environmentObject(appRootManager)
        }
    }
}
