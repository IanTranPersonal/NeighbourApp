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
                
                Text("Greeting Name")
                
                // Insert Summary View Here
                SummaryView()
                
                
                
                
                Rectangle()
                    .fill(.green)
                    .frame(width: UIScreen.main.bounds.width - 20, height: 100)
                    .cornerRadius(12)
                    .shadow(radius: 8)
                    .overlay {
                        Button("Start New Quote") {
                            router.navigate(to: .newQuote)
                        }
                        .foregroundColor(.white)
                    }
                
                Rectangle()
                    .fill(.blue)
                    .frame(width: UIScreen.main.bounds.width - 20, height: 100)
                    .cornerRadius(12)
                    .shadow(radius: 8)
                    .overlay {
                        Button("View Existing Jobs") {
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
    
    private var greeting: String {
        let time = Calendar.current.component(.hour, from: Date())
        switch time {
        case 0...3:
            return "Good Evening"
        case 3...12:
            return "Good Morning"
        case 12...6:
            return "Good Afternoon"
        default:
            return "Good Evening"
        }
    }
}

#Preview {
    ContentView().environmentObject(Base())
}
