//
//  NewItemView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 14/7/2024.
//

import SwiftUI
import Observation

struct NewItemView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var base: Base
    @State var viewModel = NewItemViewModel()
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
                    TextField("", value: $viewModel.amount, format: .currency(code: "AUD"))
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
                Rectangle()
                    .fill(.blue)
                    .cornerRadius(8)
                    .frame(width: 80, height: 80)
                    .shadow(radius: 10)
                    .overlay {
                        Button {
                            showNotes.toggle()
                        } label: {
                            VStack{
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("Notes")
                            }
                            .foregroundColor(.white)
                        }
                    }
                Rectangle()
                    .fill(.blue)
                    .cornerRadius(8)
                    .frame(width: 80, height: 80)
                    .shadow(radius: 10)
                    .overlay {
                        Button {
                            withAnimation(.linear){
                                showCustomer.toggle()
                            }
                        } label: {
                            VStack {
                                Image(systemName: "person.fill.badge.plus")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("Customer")
                            }
                            .foregroundColor(.white)
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
        .sheet(isPresented: $showCustomer) {
            CustomerView(name: $viewModel.customer.name, email: $viewModel.customer.email, phoneNumber: $viewModel.customer.phoneNumber, isShowing: $showCustomer)
        }
    }
    
    
}



#Preview {
    NewItemView(viewModel: NewItemViewModel()).environmentObject(Base())
}

@MainActor
@Observable
class NewItemViewModel {
    var quoteItems: [QuoteItems] = []
    var reference: String = ""
    var amount: Double = 0.00
    var additionalNotes: String = ""
    var customer: Customer = Customer.empty
    
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
        return Quote(items: quoteItems, reference: reference, amount: amount, notes: additionalNotes, customer: customer, total: amount)
    }
}

