//
//  ExistingQuotesView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 15/7/2024.
//

import SwiftUI

struct ExistingQuotesView: View {
    @EnvironmentObject var base: Base
    var body: some View {
            List {
                ForEach(base.quote) { quote in
                    NavigationLink(destination: SingleExistingQuoteView(viewModel: ExistingQuoteViewModel(id: quote.id ?? UUID().uuidString.lowercased(), quoteItems: quote.items ?? [], price: quote.amount ?? 0, status: quote.status, reference: quote.reference ?? "", notes: quote.notes ?? "", customer: quote.customer ?? .empty, paidAmount: quote.paidAmount ?? 0, total: quote.total ?? 0))) {
                        ExistingQuoteSummaryView(quote: quote)
                    }
                }
                .onDelete(perform: { indexSet in
                    base.quote.remove(atOffsets: indexSet)
                })
        }
        .navigationTitle("Existing Quotes")
        .onAppear(perform: {
            Task {
                await base.retrieveData()
            }
        })
    }
}

#Preview {
    ExistingQuotesView().environmentObject(Base())
}
