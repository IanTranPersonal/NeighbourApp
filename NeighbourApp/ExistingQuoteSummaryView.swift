//
//  ExistingQuoteSummaryView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 15/7/2024.
//

import SwiftUI

struct ExistingQuoteSummaryView: View {
    var quote: Quote
    var body: some View {
        HStack(alignment: .center, spacing: 60) {
            VStack(alignment: .leading ,spacing: 10){
                Text(quote.reference ?? "First")
                    .bold()
                
                Text(quote.status.capitalized)
                    .foregroundColor(statusColor)
            }
            Text("$\(String(format: "%.2f", quote.amount ?? 0.00))")
        }
    }
    private var statusColor: Color {
        switch quote.status {
        case "deposit":
            return .orange
        case "paid":
            return .green
        default:
            return .blue
        }
    }
}

#Preview {
    ExistingQuoteSummaryView(quote: Quote())
}
