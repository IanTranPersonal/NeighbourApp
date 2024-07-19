//
//  EditQuoteItemsView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 18/7/2024.
//

import SwiftUI

struct EditQuoteItemsView: View {
    @EnvironmentObject var base: Base
    var id: String
    private let itemOptions = Constants.items
    @State var items: [String] = ["String 1", "String 2", "String 3"]
    var body: some View {
        VStack {
            List {
                ForEach(items.indices, id: \.self) { index in
                    Picker("Item", selection: $items[index]) {
                        ForEach(itemOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    items.remove(atOffsets: indexSet)
                })
            }
            
            Button("Save changes") {
                updateItems()
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Edit Quote")
        .toolbar {
            ToolbarItem {
                Button(action: addItem) {
                    Text("Add Item")
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    private func updateItems() {
        Task {
            await base.updateQuoteItems(for: id, with: items)
        }
    }
    private func addItem() {
        items.append(itemOptions.first ?? "")
    }
}

#Preview {
    EditQuoteItemsView(id: UUID().uuidString.lowercased()).environmentObject(Base())
}
