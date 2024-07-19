//
//  ContentView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 14/7/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var router = Router()
    var body: some View {
        NavigationStack(path: $router.navPath) {
            VStack(spacing: 50) {
                Rectangle()
                    .fill(.green)
                    .frame(width: 100, height: 100)
                    .cornerRadius(5)
                    .shadow(radius: 8)
                    .overlay {
                        Button("New") {
                            router.navigate(to: .newQuote)
                        }
                        .foregroundColor(.white)
                    }
                
                Rectangle()
                    .fill(.blue)
                    .frame(width: 100, height: 100)
                    .cornerRadius(5)
                    .shadow(radius: 8)
                    .overlay {
                        Button("Existing") {
                            router.navigate(to: .existing)
                        }
                        .foregroundColor(.white)
                    }
            }
            .navigationDestination(for: Router.Destination.self, destination: { destination in
                switch destination {
                case .newQuote:
                    NewItemView().environmentObject(router)
                case .existing:
                    ExistingQuotesView().environmentObject(router)
                }
            })
        }
        
    }
}

#Preview {
    ContentView().environmentObject(Base())
}
