//
//  RecordPaymentView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 22/7/2024.
//

import SwiftUI

struct RecordPaymentView: View {
    @Binding var paidAmount: Double
    @Binding var amount: Double
    @Binding var isPresented: Bool
    @Binding var status: String
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Text("Paid: $")
                TextField("", value: $paidAmount, format: .number)
                    .frame(width: 175, height: 50)
                    .border(.gray)
                    .keyboardType(.decimalPad)
                Spacer()
            }
            Text("Due $\(max(amount, 0), specifier: "%.2f")")
                .offset(x: 0, y: 50)
            Button("Done") {
                withAnimation(.linear) {
                    isPresented = false
                }
                withAnimation(.smooth) {
                    updateValues()
                }
            }
            .offset(y: 100)
            .buttonStyle(.borderedProminent)
        }
    }
    private var due: Double {
        amount - paidAmount
    }
    private func updateValues() {
        guard amount >= 0 else { return }
        let newPrice = amount - paidAmount
        amount = max(newPrice, 0)
        if amount == 0 {
            status = "paid"
        }
        else if paidAmount != 0.00 {
            status = "deposit"
        }
        else {
            status = "quote"
        }
    }
}

#Preview {
    RecordPaymentView(paidAmount: .constant(0), amount: .constant(5000), isPresented: .constant(true), status: .constant("quote"))
}
