//
//  DeleteAccountConfirmation.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 2/8/2024.
//

import SwiftUI
import FirebaseAuth

struct DeleteAccountConfirmation: View {
    @EnvironmentObject var appRootManager: AppRootManager
    @Binding var presentDelete: Bool
    var body: some View {
        Text("Warning")
            .bold()
            .padding(.top, 20)
        Text("This operation can not be undone.")
            .padding(.bottom, 30)
        
        Button("Yes") {
            if let user = Auth.auth().currentUser {
                user.delete() { error in
                    if error != nil {
                        print("Something went wrong")
                    }
                    else {
                        withAnimation(.easeInOut) {
                            print("deleting")
                            appRootManager.currentRoot = .authentication
                        }
                    }
                }
            }
        }
        .frame(width: 150, height: 50)
        .background(.red)
        .foregroundColor(.white)
        .cornerRadius(5)
        .shadow(radius: 5)
        .padding(.bottom, 20)
        
        Button("Nevermind") {
            presentDelete = false
        }
        .frame(width: 150, height: 50)
        .background(.blue)
        .foregroundColor(.white)
        .cornerRadius(5)
        .shadow(radius: 5)
        .padding(.bottom, 50)
        
        
    }
}

#Preview {
    DeleteAccountConfirmation(presentDelete: .constant(true)).environmentObject(AppRootManager())
}

