//
//  LoginView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 28/7/2024.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var router: AuthRouter
    @State var username: String = ""
    @State var password: String = ""
    var body: some View {
        ZStack {
            Image("Designer2").opacity(0.2)
            VStack(spacing: 30) {
                Spacer()
                Text("Welcome Back")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                ZStack(alignment: .leading) {
                    Text("Email")
                        .offset(y: -35)
                    TextField(" Email", text: $username)
                        .frame(width: 250, height: 40, alignment: .center)
                        .border(Color.black)
                }
                .padding(.bottom, 10)
                
                ZStack(alignment: .leading) {
                    Text("Password")
                        .offset(y: -35)
                    SecureField(" Password", text: $password)
                        .frame(width: 250, height: 40, alignment: .center)
                        .border(Color.black)
                }
                
                Button("Log in") {
                    print("log in")
                }
                .buttonStyle(.borderedProminent)
            Spacer()
            }
        }
    }
}

#Preview {
    LoginView().environmentObject(AuthRouter())
}
