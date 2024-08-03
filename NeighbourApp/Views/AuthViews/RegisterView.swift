//
//  RegisterView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 28/7/2024.
//

import SwiftUI
import FirebaseAuth
import Observation

struct RegisterView: View {
    @EnvironmentObject var router: AuthRouter
    @State var viewModel = RegisterViewModel()
    @State private var buttonPressed: Bool = false
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $viewModel.name)
                EmailTextField(email: $viewModel.email)
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
                    .keyboardType(.numberPad)
                TextField("BSB", text: $viewModel.bsb)
                    .keyboardType(.numberPad)
                TextField("Account Number", text: $viewModel.accNo)
                    .keyboardType(.numberPad)
                
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
                    buttonPressed = true
                    Task {
                        await viewModel.createUser()
                        if viewModel.goodTogo {
                            router.navigateToRoot()
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.easeInOut(duration: 2)){
                            buttonPressed = false
                            viewModel.debugString = nil
                        }
                    }
                }
                .disabled(buttonPressed)
            }
            if let errorText = viewModel.debugString {
                Text(errorText)
                    .foregroundColor(.red)
                Text("Please try again")
                    .foregroundColor(.red)
            }
        }
        .background {
            Image("Designer3").opacity(0.25)
        }
        .foregroundStyle(.primary)
        .scrollContentBackground(.hidden)
        .navigationTitle("Register")
    }
}

#Preview {
    RegisterView().environmentObject(AuthRouter())
}

@Observable
class RegisterViewModel {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var businessName: String = ""
    var abn: String = ""
    var accNo: String = ""
    var bsb: String = ""
    var debugString: String?
    var goodTogo: Bool = false
    let viewModel = UserModel.instance
    @MainActor
    func createUser() async {
        do {
            let user = try await Auth.auth().createUser(withEmail: email, password: password)
            goodTogo = true
            viewModel.user.email = user.user.email ?? email
            if !name.isEmpty {
                viewModel.user.name = name
            }
            if !businessName.isEmpty || !abn.isEmpty || !bsb.isEmpty || !accNo.isEmpty {
                viewModel.user.businessName = businessName
                viewModel.user.abn = abn
                viewModel.user.bsb = bsb
                viewModel.user.accNo = accNo
            }
            viewModel.saveChanges()
        }
        catch {
            print(error.localizedDescription)
            debugString = error.localizedDescription
        }
    }
}
