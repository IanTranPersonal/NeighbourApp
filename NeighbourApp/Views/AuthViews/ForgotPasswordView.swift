//
//  ForgotPasswordView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 1/8/2024.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @Binding var isPresented: Bool
    @State var email: String
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blue.quaternary)
                .frame(width: UIScreen.main.bounds.width, height: 300)
                .cornerRadius(10)
                .shadow(radius: 10)
                .background()
            VStack(alignment: .center, spacing: 20) {
                Text("Please enter your email")
                    .font(.title3)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                
                TextField("", text: $email)
                    .frame(width: 200)
                    .border(Color.gray.opacity(0.8))
                
                Button("Reset") {
                    guard email.isValidEmail else {
                        return
                    }
                    Auth.auth().sendPasswordReset(withEmail: email)
                    isPresented = false
                    
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    ForgotPasswordView(isPresented: .constant(true), email: "")
}
