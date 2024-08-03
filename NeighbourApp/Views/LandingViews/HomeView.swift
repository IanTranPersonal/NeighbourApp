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
    @StateObject private var user = UserModel.instance
    @StateObject private var imageManager = ImageStorageManager()
    var body: some View {
        NavigationStack(path: $router.navPath) {
            VStack(spacing: 50) {
                
                Text(greeting)
                    .font(.largeTitle)
                    .foregroundStyle(Color.customYellow)
                Capsule()
                    .fill(Color.deepBlue.opacity(0.75))
                    .frame(width: 300, height: 3)
                    .padding(.top, -40)
                
                SummaryView()
                    .shadow(color: .skyBlue, radius: 1)
                
                Capsule()
                    .fill(Color.prussianBlue)
                    .frame(width: UIScreen.main.bounds.width - 20, height: 100)
                    .cornerRadius(12)
                    .shadow(color: .skyBlue, radius: 5)
                    .overlay {
                        Button {
                            router.navigate(to: .newQuote)
                        } label: {
                            HStack {
                                Text("Start New Quote")
                                    .foregroundStyle(Color.customYellow)
                                    .font(.title3)
                                    .padding( 30)
                                
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(Color.customYellow)
                            }
                        }
                    }
                
                Capsule()
                    .fill(Color.prussianBlue)
                    .frame(width: UIScreen.main.bounds.width - 20, height: 100)
                    .cornerRadius(12)
                    .shadow(color: .skyBlue, radius: 5)
                    .overlay {
                        Button {
                            router.navigate(to: .existing)
                        } label: {
                            HStack {
                                Text("View Existing Jobs")
                                    .foregroundStyle(Color.customYellow)
                                    .font(.title3)
                                    .padding(30)
                                
                                Image(systemName: "list.clipboard")
                                    .resizable()
                                    .frame(width: 40, height: 50)
                                    .foregroundStyle(Color.customYellow)
                            }
                        }
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
        
        .onAppear(perform: {
            if user.user == UserModel.emptyUser {
                user.retrieveUser()
            }
            if user.userLogo == nil {
                getImage()
            }
        })
    }
    
    private func getImage() {
        Task {
            guard !user.user.email.isEmpty else { return }
            try await imageManager.retrieveImage(userId: user.user.email)
            if let image = imageManager.selectedImage {
                user.userLogo = image
            }
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
