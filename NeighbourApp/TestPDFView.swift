//
//  TestPDFView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 19/7/2024.
//

import SwiftUI

struct TestPDFView: View {
    let pdfUrl = Bundle.main.url(forResource: "Sample", withExtension: "pdf")!
    var body: some View {
        PDFKitView(url: pdfUrl)
            .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height - 20, alignment: .center)
            .scaledToFill()
    }
}

#Preview {
    TestPDFView()
}
