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
        }
    }
    
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
            let newValues: [String: Any] = [
                "items": item.items ?? [],
                "reference": item.reference ?? "",
                "status": item.status,
                "amount": item.amount ?? 0.00
            ]
            
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
    
    
}
