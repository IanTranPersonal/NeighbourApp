//
//  TestImageView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 1/8/2024.
//

import SwiftUI

struct TestImageView: View {
    @StateObject private var imageManager = ImageStorageManager()
    @State private var isFilePickerPresented = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    let userId = "user123" // This should be the actual user's ID
    
    var body: some View {
        VStack {
            if let image = imageManager.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } else {
                Text("No image selected")
            }
            
            Button("Select Image File") {
                isFilePickerPresented = true
            }
            
            Button("Upload Image") {
                uploadImage()
            }
            .disabled(imageManager.selectedImage == nil || isLoading)
            
            Button("Retrieve Image") {
                retrieveImage()
            }
            .disabled(isLoading)
            
            if isLoading {
                ProgressView()
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
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
                    }
                }
            } catch {
                print("Error selecting file: \(error.localizedDescription)")
            }
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
    
    private func retrieveImage() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await imageManager.retrieveImage(userId: userId)
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}

#Preview {
    TestImageView()
}
