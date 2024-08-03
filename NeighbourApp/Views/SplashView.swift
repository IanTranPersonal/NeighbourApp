//
//  SplashView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 1/8/2024.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var appRootManager: AppRootManager
    var body: some View {
        VStack{
            Image("Loading")
                .resizable()
                .scaledToFill()
                .offset(x: -20)
                .ignoresSafeArea()
        }
        .onAppear() {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.spring()) {
                    appRootManager.currentRoot = appRootManager.loadUser()
                }
            }
        }
            
    }
        
}

#Preview {
    SplashView().environmentObject(AppRootManager())
}
