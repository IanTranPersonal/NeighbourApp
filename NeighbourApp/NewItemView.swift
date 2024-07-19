//
//  NewItemView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 14/7/2024.
//

import SwiftUI

struct NewItemView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var base: Base
    @State private var quoteItems: [String] = []
    @State private var reference: String = ""
    @State private var amount: Double = 0.00
    private let itemOptions = Constants.items
    @State private var additionalNotes: String = ""
    @State var showNotes: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center, spacing: 25){
                Text("Reference")
                TextField("  Reference", text: $reference)
                    .frame(width: 150, height: 40)
                    .border(.black)
                    .cornerRadius(3)
            }
            List {
                ForEach(quoteItems.indices, id: \.self) { index in
                    Picker("Item", selection: $quoteItems[index]) {
                        ForEach(itemOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    quoteItems.remove(atOffsets: indexSet)
                })
            }
            
            HStack{
                Text("$")
                TextField("Amount", value: $amount, format: .number)
                    .frame(width: 150, height: 40)
                    .border(.black)
                    .cornerRadius(3)
            }
            
            HStack(spacing: 30) {
                Button(action: addItem) {
                    Text("Add Item")
                }
                .buttonStyle(.borderedProminent)
                Button {
                    showNotes.toggle()
                } label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    let newQuote = Quote(items: quoteItems, reference: reference, amount: amount, notes: additionalNotes)
                    Task {
                        await base.addData(for: newQuote)
                        router.navigateToRoot()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("New Quote")
        
        .sheet(isPresented: $showNotes) {
            QuoteNoteView(note: $additionalNotes, isPresented: $showNotes)
                .presentationDetents([.height(300)])
        }
    }
    
    private func addItem() {
        quoteItems.append(itemOptions.first ?? "")
    }
}



#Preview {
    NewItemView().environmentObject(Base())
}
