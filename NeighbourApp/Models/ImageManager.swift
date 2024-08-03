//
//  ImageManager.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 1/8/2024.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

@MainActor
class ImageStorageManager: ObservableObject {
    @Published var selectedImage: UIImage?
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    func uploadImageFile(at url: URL, userId: String) async throws {
        let storageRef = storage.reference().child("images/\(userId)/profile.jpg")
        
        do {
            let _ = try await storageRef.putFileAsync(from: url)
            print("Image uploaded successfully")
            
            let downloadURL = try await storageRef.downloadURL()
            try await saveImageUrlToFirestore(userId: userId, url: downloadURL.absoluteString)
        } catch {
            print("Error uploading image: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func saveImageUrlToFirestore(userId: String, url: String) async throws {
        do {
            try await db.collection("users").document(userId).setData(["profileImageUrl": url], merge: true)
            print("Image URL saved to Firestore")
        } catch {
            print("Error saving image URL: \(error.localizedDescription)")
            throw error
        }
    }
    
    func retrieveImage(userId: String) async throws {
        do {
            let document = try await db.collection("users").document(userId).getDocument()
            
            guard let urlString = document.data()?["profileImageUrl"] as? String,
                  let url = URL(string: urlString) else {
                throw URLError(.badServerResponse)
            }
            
            self.selectedImage = try await downloadImage(from: url)
        } catch {
            print("Error retrieving image: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func downloadImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        return image
    }
}
