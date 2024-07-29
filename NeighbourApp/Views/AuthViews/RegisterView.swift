//
//  RegisterView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 28/7/2024.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var router: AuthRouter
    @StateObject var viewModel = RegisterViewModel()
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $viewModel.name)
                TextField("Email", text: $viewModel.email)
                SecureField("Password", text: $viewModel.password)
            } header: {
                HStack{
                    Text("Your Details")
                    Spacer()
                    Text("Required")
                }
            }
            Section {
                TextField("Business Name", text: $viewModel.businessName)
                TextField("ABN", text: $viewModel.abn)
                TextField("BSB", text: $viewModel.bsb)
                TextField("Account Number", text: $viewModel.accNo)
                
            } header: {
                HStack {
                    Text("Business Details")
                    Spacer()
                    Text("Optional")
                }
            }
        
            footer: {
                Text("You can fill this in later also")
            }
            Section {
                Button("Save") {
                    print("Saved")
                }
            }
        }
        .background {
            Image("Designer3").opacity(0.25)
        }
        .foregroundStyle(.black)
        .scrollContentBackground(.hidden)
        .navigationTitle("Register")
    }
}

#Preview {
    RegisterView().environmentObject(AuthRouter())
}

class RegisterViewModel: ObservableObject {
   @Published var name: String = ""
   @Published var email: String = ""
   @Published var password: String = ""
   @Published var businessName: String = ""
   @Published var abn: String = ""
   @Published var accNo: String = ""
   @Published var bsb: String = ""
}
