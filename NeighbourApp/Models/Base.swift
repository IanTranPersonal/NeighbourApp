//
//  Base.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 14/7/2024.
//

import Foundation
import FirebaseFirestore
import Combine

class Base: ObservableObject {
    @Published var quote: [Quote] = []
    
    private lazy var db = Firestore.firestore()
    
    func addData(for item: Quote) async {
        do {
            let encoder = try Firestore.Encoder().encode(item)
            try await db.collection("quotes").addDocument(data: encoder)
        }
        catch {
            print(error.localizedDescription)
            print("Failed to add data")
        }
    }
    
//    func submitItem(for item: Quote) async throws{
//        do {
//            guard let ep = URL(string: "ep") else { return }
//            let authorisationToken = "TBA"
//            var request = URLRequest(url: ep)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue(authorisationToken, forHTTPHeaderField: "Authorization")
//            let encoder = try JSONEncoder().encode(item)
//            let (data, response) = try await URLSession.shared.upload(for: request, from: encoder)
//            guard let returnedResponse = response as? HTTPURLResponse, returnedResponse.statusCode == 200 else {
//                throw CallErrors.uploadFailed
//            }
//            print("Successfully sent item")
//            
//        }
//        catch {
//            print(error.localizedDescription)
//        }
//    }
    
    @MainActor
    func retrieveData() async {
        do {
            let snapshot = try await db.collection("quotes").getDocuments()
            let documents = try snapshot.documents.map {try $0.data(as: Quote.self)}
            quote.removeAll()
            quote = documents
        }
        catch {
            print("Failed to retrieve data")
            print(error.localizedDescription)
        }
    }
    
//    func retrieveDataNew() async throws {
//        do {
//            guard let ep = URL(string: "ep") else { return }
//            let authorizationToken = "TBA"
//            var request = URLRequest(url: ep)
//            request.setValue(authorizationToken, forHTTPHeaderField: "Authorization")
//            let (data, response) = try await URLSession.shared.data(for: request)
//            guard let returned = response as? HTTPURLResponse, returned.statusCode == 200 else {
//                throw CallErrors.retrieveFailed
//            }
//            let result = try JSONDecoder().decode(Quote.self, from: data)
//            
//        }
//    }
    
    @MainActor
    func retrieveSingleQuote(for id: String) async -> Quote? {
        do {
            let item = db.collection("quotes").document(id)
            let quote = try await item.getDocument()
            if quote.exists {
                return try quote.data(as: Quote.self)
            }
        }
        catch {
            print("Failed to retrieve single item")
        }
        return nil
    }
    
    func updateItem(for item: Quote) async {
        do {
            guard let itemId = item.id else { return }
            let collection = db.collection("quotes").document(itemId)
            let newValues = try Firestore.Encoder().encode(item)
            try await collection.updateData(newValues)
            print("Document Updated")
        }
        
        catch {
            print("Updating failed")
        }
    }
    
    func updateQuoteItems(for id: String, with items: [String]) async {
        do {
            let collection = db.collection("quotes").document(id)
            try await collection.updateData(["items": items])
            print("Updated quote items")
        }
        catch {
            print("unable to update quote items")
        }
    }
    
    // TODO: Remove quote
    
    
}

enum CallErrors: Error {
    case uploadFailed
    case retrieveFailed
}
