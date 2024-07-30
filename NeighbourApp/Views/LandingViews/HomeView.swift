//
//  HomeView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 29/7/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var base: Base
    @EnvironmentObject var router: Router
    var body: some View {
        NavigationStack(path: $router.navPath) {
            VStack(spacing: 50) {
                
                Text(greeting)
                    .font(.largeTitle)
                
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
    
    var greeting: String {
        let time = Calendar.current.component(.hour, from: .now)
        switch time {
        case 0...3:
            return "Good Evening"
        case 4...11:
            return "Good Morning"
        case 12...17:
            return "Good Afternoon"
        default:
            return "Good Evening"
        }
    }
}

#Preview {
    HomeView().environmentObject(Base()).environmentObject(Router())
}
