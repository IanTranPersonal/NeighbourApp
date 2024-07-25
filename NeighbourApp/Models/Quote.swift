//
//  Quote.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 15/7/2024.
//

import Foundation
import FirebaseFirestore

struct Quote: Codable, Identifiable {
    @DocumentID var id: String?
    var items: [QuoteItems]?
    var reference: String?
    var status: String = jobStatus.quote.rawValue
    var amount: Double?
    var notes: String?
    var companyCode: String?
    var customer: Customer?
    var paidAmount: Double?
}

struct QuoteItems: Codable, Hashable {
    var item: String
    var itemNote: String
}


struct Customer: Codable, Hashable {
    var name: String
    var email: String
    var phoneNumber: String
    
    static let empty: Customer = Customer(name: "", email: "", phoneNumber: "")
}

enum jobStatus: String, CaseIterable {
    case quote
    case deposit
    case paid
}

class Constants {
    static let items = [
        QuoteItems(item: "Item 1", itemNote: ""),
        QuoteItems(item: "Item 2", itemNote: ""),
        QuoteItems(item: "Item 3", itemNote: "")
    ]
    static let quotes = jobStatus.allCases.map { $0.rawValue}
    
    static let pdfURL = Bundle.main.url(forResource: "Sample", withExtension: "pdf")
}

