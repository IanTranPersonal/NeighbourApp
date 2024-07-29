//
//  ContentView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 14/7/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.circle.fill") }
        }
    }
}

#Preview {
    ContentView().environmentObject(Base()).environmentObject(Router())
}
