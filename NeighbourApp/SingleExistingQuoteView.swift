//
//  SingleExistingQuoteView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 16/7/2024.
//

import SwiftUI

struct SingleExistingQuoteView: View {
    @EnvironmentObject var base: Base
    var id: String
    @State var quoteItems: [String]
    @State var price: Double
    var jobStatus: [String] = ["quote", "deposit", "paid"]
    @State var statusSelection: String
    @State var reference: String
    @State var notes: String
    @State private var isShowingText: Bool = false
    var body: some View {
        ZStack {
            VStack {
                Text("Reference: \(reference)")
                    .bold()
                
                Picker("Status", selection: $statusSelection) {
                    ForEach(jobStatus, id: \.self) {
                        Text($0.capitalized)
                    }
                }
                NavigationLink("Items", destination: {EditQuoteItemsView(id: id, items: quoteItems)})
                ForEach(quoteItems.indices, id: \.self) { index in
                    TextEditor(text: $quoteItems[index])
                        .frame(width: 300, height: 40, alignment: .center)
                }
                HStack{
                    Text("$")
                    TextField("Amount", value: $price, format: .number)
                        .frame(width: 150, height: 40)
                        .border(.black)
                        .cornerRadius(3)
                        .keyboardType(.decimalPad)
                }
                .padding(.bottom, 20)
                Button(isShowingText ? "Hide Note" : "Edit Note") {
                        isShowingText.toggle()
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 50)
                Button("Refresh") {
                    Task {
                        let current = await base.retrieveSingleQuote(for: id)
                        quoteItems = current?.items ?? []
                    }
                }
                .buttonStyle(.bordered)
            }
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        updateResults()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .sheet(isPresented: $isShowingText) {
                QuoteNoteView(note: $notes, isPresented: $isShowingText)
                    .presentationDetents([.height(300)])
            }
        }
        
        
    }
    private func updateResults() {
        let quote = Quote(id: id, items: quoteItems, reference: reference, status: statusSelection, amount: price)
        Task {
            await base.updateItem(for: quote)
        }
    }
}

#Preview {
    SingleExistingQuoteView(id: "", quoteItems: [], price: 0, jobStatus: [], statusSelection: "quote", reference: "", notes: "")
}
