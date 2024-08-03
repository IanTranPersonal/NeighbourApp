//
//  RecordPaymentView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 22/7/2024.
//

import SwiftUI

struct RecordPaymentView: View {
    @ObservedObject var mainViewModel: ExistingQuoteViewModel
    @State var paidAmount: Double = 0
    @State var amount: Double
    @Binding var received: Double
    @Binding var isPresented: Bool
    @Binding var status: String
    var body: some View {
        ZStack(alignment: .center) {
            Text("Received: \(received.formatted(.currency(code: "AUD")))")
                .offset(x: 0, y: -70)
            VStack {
                Text("New Payment")
                TextField("$", value: $paidAmount, format: .number)
                    .frame(width: 175, height: 50)
                    .border(.gray)
                    .keyboardType(.decimalPad)
            }
            Text("Balance $\(max(amount, 0), specifier: "%.2f")")
                .offset(x: 0, y: 70)
            Button("Done") {
                withAnimation(.linear) {
                    isPresented = false
                    updateValues()
                }
            }
            .offset(y: 120)
            .buttonStyle(.borderedProminent)
        }
    }
    private var due: Double {
        amount - paidAmount
    }
    private func updateValues() {
        guard amount >= 0 else { return }
        let newPrice = amount - paidAmount
        mainViewModel.paidAmount += paidAmount
        mainViewModel.price = newPrice
        if newPrice == 0 {
            status = "paid"
        }
        else if newPrice != 0.00 {
            status = "deposit"
        }
        else {
            status = "quote"
        }
    }
}

#Preview {
    RecordPaymentView(mainViewModel: ExistingQuoteViewModel(id: "", quoteItems: Constants.items, price: 5000, status: "quote", reference: "ABC", notes: "", customer: Customer.empty, paidAmount: 0, total: 5000), paidAmount: 0, amount: 5000, received: .constant(500), isPresented: .constant(true), status: .constant("quote"))
}
