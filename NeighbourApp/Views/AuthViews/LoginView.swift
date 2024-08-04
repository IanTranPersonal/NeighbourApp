//
//  LoginView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 28/7/2024.
//

import SwiftUI
import FirebaseAuth
import Observation

struct LoginView: View {
    @EnvironmentObject var router: AuthRouter
    @State private var buttonPressed: Bool = false
    @State var viewModel = SignInViewModel()
    @State var isPresented: Bool = false
    var body: some View {
        ZStack {
            Image("Designer3").opacity(0.2)
            VStack(spacing: 30) {
                Spacer()
                Text("Welcome Back")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                if let error = viewModel.signInError {
                    Rectangle()
                        .fill(Color.black)
                        .cornerRadius(5)
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 75)
                        .overlay {
                            Text(error)
                                .foregroundColor(.red)
                                .bold()
                        }
                }
                
                ZStack(alignment: .leading) {
                    Text("Email")
                        .offset(y: -35)
                    EmailTextField(email: $viewModel.userName)
                                                .textInputAutocapitalization(.never)
                                                .textContentType(.emailAddress)
                                                .keyboardType(.emailAddress)
                                                .autocorrectionDisabled()
                        .frame(width: 250, height: 40, alignment: .center)
                        .border(Color.black)
                }
                .padding(.bottom, 10)
                
                
                ZStack(alignment: .leading) {
                    Text("Password")
                        .offset(y: -35)
                    SecureField(" Password", text: $viewModel.password)
                        .frame(width: 250, height: 40, alignment: .center)
                        .border(Color.black)
                }
                
                Button("Sign In") {
                    buttonPressed = true
                    Task {
                        await viewModel.signIn()
                        if viewModel.signInError == nil {
                            router.navigateToRoot()
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.easeInOut) {
                            viewModel.signInError = nil
                        }
                        buttonPressed = false
                    }
                }
                .padding(.top, 20)
                .buttonStyle(.borderedProminent)
                .disabled(buttonPressed)
                
                Button("Forgot Password") {
                    withAnimation {
                        isPresented.toggle()
                    }
                }
                
                .sheet(isPresented: $isPresented){
                    ForgotPasswordView(isPresented: $isPresented, email: viewModel.userName)
                        .presentationDetents([.height(200)])
                }
                
            Spacer()
            }
        }
    }
}

#Preview {
    LoginView().environmentObject(AuthRouter())
}

@Observable
class SignInViewModel {
    var userName: String = ""
    var password: String = ""
    var signInError: String?
    var viewModel = UserModel.instance
    
    func signIn() async {
        do {
            let user = try await Auth.auth().signIn(withEmail: userName, password: password)
            viewModel.user.email = user.user.email ?? userName
            viewModel.saveChanges()
        }
        catch {
            signInError = error.localizedDescription
        }
    }
    
}
