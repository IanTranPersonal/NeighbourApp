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
    var items: [String]?
    var reference: String?
    var status: String = jobStatus.quote.rawValue
    var amount: Double?
    var notes: String?
}

enum jobStatus: String {
    case quote
    case deposit
    case paid
}

class Constants {
    static let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
}

