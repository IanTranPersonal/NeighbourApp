//
//  ProfileView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 29/7/2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = UserModel.instance
    var body: some View {
        Form {
            Section(header: Text("Personal Info")) {
                TextField("Name", text: $viewModel.user.name)
                TextField("Email", text: $viewModel.user.email)
            }
            Section {
                TextField("Business Name", text: $viewModel.user.businessName)
                TextField("ABN", text: $viewModel.user.abn)
                TextField("BSB", text: $viewModel.user.bsb)
                TextField("Account Number", text: $viewModel.user.accNo)
            } header: {
                Text("Business Information")
            } footer: {
                Text("You'll want to add this information in for your Invoices and Quotes")
            }
            Section {
                Button("Save") {
                    guard viewModel.isValidForm else { return }
                    viewModel.saveChanges()
                }
                .foregroundStyle(.blue)
                Button("Logout") {
                    print("Logged out")
                }
                .foregroundStyle(.red)
            }
            
            Section(header: Text("Delete Account")) {
                Button("Delete Account") {
                    print("Delete account")
                }
                .bold()
                .foregroundStyle(.red)
            }
        }
        .foregroundStyle(.primary)
        .onAppear(perform: {
            viewModel.retrieveUser()
        })
    }
    
}

#Preview {
    ProfileView()
}
