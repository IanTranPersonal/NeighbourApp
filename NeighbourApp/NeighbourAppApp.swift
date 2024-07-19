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
    var base = Base()
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.environmentObject(base)
    }
}
