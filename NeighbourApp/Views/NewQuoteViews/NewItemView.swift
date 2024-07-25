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
    @StateObject var viewModel = NewItemViewModel()
    private let itemOptions = Constants.items.map {$0.item}
    @State var showNotes: Bool = false
    @State var showCustomer: Bool = false
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 25){
                Text("Reference")
                TextField("  Reference", text: $viewModel.reference)
                    .frame(width: 150, height: 40)
                    .border(.gray)
                    .cornerRadius(3)
            }
            List {
                ForEach(viewModel.quoteItems.indices, id: \.self) { index in
                    SingleCustomItemView(item: $viewModel.quoteItems[index].item, itemNote: $viewModel.quoteItems[index].itemNote)
                }
                .onDelete(perform: { indexSet in
                    viewModel.quoteItems.remove(atOffsets: indexSet)
                })
                
                Button("Add Item") {
                    viewModel.addItem()
                }
            }
            
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Total:")
                    TextField("Amount", value: $viewModel.amount, format: .currency(code: "AUD"))
                        .frame(width: 150, height: 40)
                        .border(.gray)
                        .cornerRadius(3)
                        .keyboardType(.decimalPad)
                }
                Text("Total .excl GST: \(viewModel.exGst)")
                    .padding(.bottom, 10)
                Text("GST: \(viewModel.gst)")
                
            }
            
            HStack(spacing: 50) {
                Button {
                    showNotes.toggle()
                } label: {
                    VStack{
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Notes")
                    }
                }
                Button {
                    withAnimation(.linear){
                        showCustomer.toggle()
                    }
                } label: {
                    VStack {
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .resizable()
                            .frame(width: 35, height: 30)
                        Text("Customer")
                    }
                }
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task{
                        let new = await viewModel.onTapSave()
                        await base.addData(for: new)
                        router.navigateToRoot()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("New Quote")
        
        .sheet(isPresented: $showNotes) {
            QuoteNoteView(note: $viewModel.additionalNotes, isPresented: $showNotes)
                .presentationDetents([.height(300)])
        }
        if showCustomer {
            CustomerView(name: $viewModel.customer.name, email: $viewModel.customer.email, phoneNumber: $viewModel.customer.phoneNumber, isShowing: $showCustomer)
        }
    }
    
    
}



#Preview {
    NewItemView(viewModel: NewItemViewModel()).environmentObject(Base())
}

@MainActor
class NewItemViewModel: ObservableObject {
    @Published var quoteItems: [QuoteItems] = []
    @Published var reference: String = ""
    @Published var amount: Double = 0.00
    @Published var additionalNotes: String = ""
    @Published var customer: Customer = Customer.empty
    
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
    
    func addItem() {
        quoteItems.append(QuoteItems(item:"New Item", itemNote: ""))
    }
    
    
    var gst: String {
        if amount > 0 {
            return "$\(String(format: "%.2f", amount/10))"
        }
        return "$0"
    }
    var exGst: String {
        if amount > 0 {
            return "$\(String(format: "%.2f", amount * 0.9))"
        }
        return "$0"
    }
    
    func onTapSave() async -> Quote {
        return Quote(items: quoteItems, reference: reference, amount: amount, notes: additionalNotes, customer: customer)
    }
}

