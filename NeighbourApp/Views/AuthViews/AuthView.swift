//
//  AuthView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 28/7/2024.
//

import SwiftUI

struct AuthView: View {
    @ObservedObject var router = AuthRouter()
    var body: some View {
        NavigationStack(path: $router.navPath) {
            ZStack {
                Image("Designer1")
                    .opacity(0.3)
                
                VStack {
                    Spacer()
                    Text("Welcome")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(.blue)
                        .frame(width: UIScreen.main.bounds.width - 20, height: 70)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .overlay {
                            Text("Log in")
                                .foregroundColor(.yellow)
                                .font(.title)
                        }
                        .padding(.bottom, 30)
                        .onTapGesture {
                            router.navigate(to: .signIn)
                        }
                    
                    Rectangle()
                        .fill(.blue)
                        .frame(width: UIScreen.main.bounds.width - 20, height: 70)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .overlay {
                            Text("Register")
                                .foregroundColor(.yellow)
                                .font(.title)
                        }
                    
                    .onTapGesture {
                        router.navigate(to: .register)
                    }
                    Spacer()
                }
                .navigationDestination(for: AuthRouter.Destination.self, destination: { destination in
                    switch destination {
                    case .register :
                        RegisterView().environmentObject(router)
                    case .signIn:
                        LoginView().environmentObject(router)
                    }
                })
            }
        }
        
    }
}

#Preview {
    AuthView()
}

class AuthRouter: ObservableObject {
    public enum Destination: Codable, Hashable {
        case signIn
        case register
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
