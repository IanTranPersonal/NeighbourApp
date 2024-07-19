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
                    NavigationLink(destination: SingleExistingQuoteView(id: quote.id ?? UUID().uuidString.lowercased(), quoteItems: quote.items ?? [], price: quote.amount ?? 0.00, statusSelection: quote.status, reference: quote.reference ?? "None", notes: quote.notes ?? "")) {
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
