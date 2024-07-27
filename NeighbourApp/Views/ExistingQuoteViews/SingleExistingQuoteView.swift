//
//  SingleExistingQuoteView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 16/7/2024.
//

import SwiftUI

struct SingleExistingQuoteView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var base: Base
    @ObservedObject var viewModel: ExistingQuoteViewModel
    @State private var isShowingText: Bool = false
    @State var isShowingCustomer: Bool = false
    @State var isShowingPayment: Bool = false
    var body: some View {
        VStack {
            Text("Status: \(viewModel.status.capitalized)")
            Spacer()
            Text(viewModel.price.formatted(.currency(code: "AUD")))
                .bold()
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
                .padding(.top, 20)
            }
            Spacer()
                Button("Record Payment") {
                    withAnimation(.easeInOut) {
                        isShowingPayment.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 20)
            
            
            HStack(spacing: 40) {
                Button {
                    withAnimation(.smooth){
                        isShowingText.toggle()
                    }
                } label: {
                    Rectangle()
                        .fill(.blue)
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                        .shadow(radius: 10)
                        .overlay {
                            VStack{
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("Notes")
                            }
                            .foregroundColor(.white)
                        }
                }
                
                Button {
                    withAnimation(.smooth){
                        isShowingCustomer.toggle()
                    }
                } label: {
                    Rectangle()
                        .fill(.blue)
                        .cornerRadius(8)
                        .frame(width: 80, height: 80)
                        .shadow(radius: 10)
                        .overlay {
                            VStack{
                                Image(systemName: "person.badge.key.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("Customer")
                            }
                            .foregroundColor(.white)
                        }
                }
                Rectangle()
                    .fill(.blue)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .overlay {
                        ShareLink(item: viewModel.shareItem()) {
                            Label("Email", systemImage: "envelope.fill")
                                .labelStyle(TopIconStyle())
                                .foregroundColor(.white)
                        }
                    }
            }
            if isShowingCustomer {
                CustomerView(name: $viewModel.customer.name, email: $viewModel.customer.email, phoneNumber: $viewModel.customer.phoneNumber, isShowing: $isShowingCustomer)
            }
        }
        .toolbar {
            ToolbarItem {
                Button("Save") {
                    updateResults()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .sheet(isPresented: $isShowingText) {
            QuoteNoteView(note: $viewModel.notes, isPresented: $isShowingText)
                .presentationDetents([.height(300)])
        }
        .sheet(isPresented: $isShowingPayment) {
            RecordPaymentView(paidAmount: $viewModel.paidAmount, amount: $viewModel.price, isPresented: $isShowingPayment, status: $viewModel.status)
                .presentationDetents([.height(200)])
        }
        .navigationTitle("Reference: \(viewModel.reference)")
        .padding()
    }
   
    private func updateResults() {
        Task {
            await base.updateItem(for: viewModel.quote)
        }
    }
}

#Preview {
    SingleExistingQuoteView(viewModel: ExistingQuoteViewModel(id: "", quoteItems: Constants.items, price: 888, status: "quote", reference: "ABC123", notes: "Something", customer: .empty, paidAmount: 0, total: 888))
}

class ExistingQuoteViewModel: ObservableObject {
    var id: String
    @Published var quoteItems: [QuoteItems]
    @Published var price: Double
    @Published var status: String
    @Published var reference: String
    @Published var notes: String
    @Published var customer: Customer
    @Published var paidAmount: Double
    var total: Double
    
    init(id: String, quoteItems: [QuoteItems], price: Double, status: String, reference: String, notes: String, customer: Customer, paidAmount: Double, total: Double) {
        self.id = id
        self.quoteItems = quoteItems
        self.price = price
        self.status = status
        self.reference = reference
        self.notes = notes
        self.customer = customer
        self.paidAmount = paidAmount
        self.total = total
    }
    
    var quote: Quote {
        return Quote(id: id, items: quoteItems, reference: reference, status: status, amount: price, notes: notes, customer: customer, paidAmount: paidAmount, total: total)
    }
    
    func addItem() {
        quoteItems.append(QuoteItems(item:"New Item", itemNote: ""))
    }
    
    private var fileName: String {
        "\(status.capitalized)-\(reference)"
    }
    
    func shareItem() -> URL {
        let runner = PDFGenerator.shared
        let url = status == "quote" ? Constants.quoteURL : Constants.invoiceURL
        if let pdf = runner.generatePDF(for: quote, backgroundPDF: url),
           let item = runner.savePDF(data: pdf, fileName: fileName) {
            return item
        }
        return url
    }
}

enum pdfErrors: Error {
    case urlFailed
    case pdfFailed
    case generateFailed
}

public struct TopIconStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 10) {
            configuration.icon
            configuration.title
        }
    }
}
