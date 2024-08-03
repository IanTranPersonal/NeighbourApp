//
//  ExistingQuotesView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 15/7/2024.
//

import SwiftUI

struct ExistingQuotesView: View {
    @EnvironmentObject var base: Base
    @State private var searchText = ""
    var body: some View {
            List {
                ForEach(base.quote) { quote in
                    NavigationLink(destination: SingleExistingQuoteView(viewModel: ExistingQuoteViewModel(id: quote.id ?? UUID().uuidString.lowercased(), quoteItems: quote.items ?? [], price: quote.amount, status: quote.status, reference: quote.reference, notes: quote.notes, customer: quote.customer ?? .empty, paidAmount: quote.paidAmount, total: quote.total))) {
                        ExistingQuoteSummaryView(quote: quote)
                    }
                }
                .onDelete(perform: { indexSet in
                    deleteItems(at: indexSet)
                })
        }
        .navigationTitle("Existing Quotes")
        .onAppear(perform: {
            Task {
                await base.retrieveData()
            }
        })
    }
    
    var quotes: [Quote] {
        let quotes = base.quote
        if searchText.isEmpty {
            return quotes
        }
        else {
            return quotes.filter({$0.reference.contains(searchText)})
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = base.quote[index]
            Task {
                guard let itemId = item.id else { return }
                await base.deleteItem(for: itemId)
            }
            base.quote.remove(atOffsets: offsets)
            
        }
    }
}

#Preview {
    ExistingQuotesView().environmentObject(Base())
}
