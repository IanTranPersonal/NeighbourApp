//
//  ProfileView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 29/7/2024.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var appRootManager: AppRootManager
    @StateObject var viewModel = UserModel.instance
    @StateObject private var imageManager = ImageStorageManager()
    
    @State private var isFilePickerPresented = false
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var errorMessage: String?
    @State private var presentDelete = false
    
    @FocusState private var focusedField: Field?
    
    private enum Field: Hashable {
        case name, email, businessName, abn, bsb, accountNumber
    }
    
    var body: some View {
        Form {
            DisclosureGroup("Personal Info"){
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $viewModel.user.name)
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .email }
                    EmailTextField(email: $viewModel.user.email)
                        .focused($focusedField, equals: .email)
                        .submitLabel(.done)
                }
                Section(header: Text("Delete Account")) {
                    Button("Delete Account") {
                        presentDelete.toggle()
                    }
                    .bold()
                    .foregroundStyle(.red)
                }
            }
            Section {
                TextField("Business Name", text: $viewModel.user.businessName)
                    .focused($focusedField, equals: .businessName)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .abn }
                TextField("ABN", text: $viewModel.user.abn)
                    .keyboardType(.namePhonePad)
                    .focused($focusedField, equals: .abn)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .bsb }
                TextField("BSB", text: $viewModel.user.bsb)
                    .keyboardType(.namePhonePad)
                    .focused($focusedField, equals: .bsb)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .accountNumber }
                TextField("Account Number", text: $viewModel.user.accNo)
                    .keyboardType(.namePhonePad)
                    .focused($focusedField, equals: .accountNumber)
                    .submitLabel(.done)
                TextEditorWithPlaceholder(text: $viewModel.user.termsWording)
                
                Button("Upload Logo File") {
                    isFilePickerPresented = true
                }
                .foregroundStyle(.blue)
                if let image = imageManager.selectedImage ?? viewModel.userLogo {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                }
            } header: {
                Text("Business Information")
            } footer: {
                Text(viewModel.user.businessName.isEmpty ? "You'll want to add this information in for your Invoices and Quotes" : "")
            }
            
            Section {
                Button("Save") {
                    focusedField = nil
                    guard viewModel.isValidForm else { return }
                    viewModel.saveChanges()
                    uploadImage()
                    showAlert = true
                }
                .foregroundStyle(.blue)
                .alert("Successfully Saved Your Changes" ,isPresented: $showAlert)  {
                    Button("Ok") {}
                }
                Button("Logout") {
                    logOut()
                }
                .foregroundStyle(.red)
            }
            
            
        }
        .fileImporter(
            isPresented: $isFilePickerPresented,
            allowedContentTypes: [.image],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                if selectedFile.startAccessingSecurityScopedResource() {
                    defer { selectedFile.stopAccessingSecurityScopedResource() }
                    if let imageData = try? Data(contentsOf: selectedFile),
                       let image = UIImage(data: imageData) {
                        imageManager.selectedImage = image
                        viewModel.userLogo = image
                    }
                }
            } catch {
                print("Error selecting file: \(error.localizedDescription)")
            }
        }
        .foregroundStyle(.primary)
        .onAppear(perform: {
            viewModel.retrieveUser()
        })
        .sheet(isPresented: $presentDelete) {
            DeleteAccountConfirmation(presentDelete: $presentDelete)
                .presentationDetents([.height(300)])
        }
    }
    
    private func uploadImage() {
        guard let image = imageManager.selectedImage,
              let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        isLoading = true
        errorMessage = nil
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
        
        do {
            try imageData.write(to: tempURL)
            
            Task {
                do {
                    let userId = viewModel.user.email
                    try await imageManager.uploadImageFile(at: tempURL, userId: userId)
                    isLoading = false
                    try? FileManager.default.removeItem(at: tempURL)
                } catch {
                    errorMessage = error.localizedDescription
                    isLoading = false
                    try? FileManager.default.removeItem(at: tempURL)
                }
            }
        } catch {
            errorMessage = "Error preparing image: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
            viewModel.logOutCalled()
            appRootManager.currentRoot = .authentication
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
}

#Preview {
    ProfileView()
}


struct TextEditorWithPlaceholder: View {
       @Binding var text: String
       
       var body: some View {
           ZStack(alignment: .leading) {
               if text.isEmpty {
                  VStack {
                       Text("Your Terms and Conditions...")
                           .padding(.top, 10)
                           .padding(.leading, 6)
                           .opacity(0.6)
                       Spacer()
                   }
               }
               
               VStack {
                   TextEditor(text: $text)
                       .frame(minHeight: 150, maxHeight: 300)
                       .opacity(text.isEmpty ? 0.85 : 1)
                   Spacer()
               }
           }
       }
   }
