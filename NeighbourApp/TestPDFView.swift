//
//  TestPDFView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 19/7/2024.
//

import SwiftUI
import PDFKit

struct TestPDFView: View {
    private var dummyQuote = Quote(id: UUID().uuidString.lowercased(), items: Constants.items, reference: "ABCDEFG", status: "quote", amount: 8888, notes: nil, companyCode: nil, customer: Customer(name: "Mike Armstrong", email: "mike@email.com", phoneNumber: ""), paidAmount: 500.00)
    let pdfUrl = Bundle.main.url(forResource: "Sample", withExtension: "pdf")!
    var body: some View {
        ZStack{
            PDFKitView(url: pdfUrl)
                .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height - 10)
                .scaledToFit()
        }
    }
    
}

#Preview {
    TestPDFView()
}
