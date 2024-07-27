//
//  NewQuoteTests.swift
//  NeighbourAppTests
//
//  Created by Vinh Tran on 28/7/2024.
//

import XCTest
@testable import NeighbourApp

class NewItemViewModelTests: XCTestCase {
    
    var viewModel: NewItemViewModel!
    
    @MainActor 
    override func setUp() {
        super.setUp()
        viewModel = NewItemViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testAddItem() async {
        await MainActor.run {
            XCTAssertEqual(viewModel.quoteItems.count, 0)
            
            viewModel.addItem()
            
            XCTAssertEqual(viewModel.quoteItems.count, 1)
            XCTAssertEqual(viewModel.quoteItems[0].item, "New Item")
            XCTAssertEqual(viewModel.quoteItems[0].itemNote, "")
        }
    }
    
    func testGstCalculation() async {
        await MainActor.run {
            viewModel.amount = 100.00
            XCTAssertEqual(viewModel.gst, "$10.00")
            
            viewModel.amount = 0
            XCTAssertEqual(viewModel.gst, "$0")
            
            viewModel.amount = 55.55
            XCTAssertEqual(viewModel.gst, "$5.55")
        }
    }
    
    func testExGstCalculation() async {
        await MainActor.run {
            viewModel.amount = 100.00
            XCTAssertEqual(viewModel.exGst, "$90.00")
            
            viewModel.amount = 0
            XCTAssertEqual(viewModel.exGst, "$0")
            
            viewModel.amount = 55.55
            XCTAssertEqual(viewModel.exGst, "$49.99")
        }
    }
    
    func testOnTapSave() async {
        await MainActor.run {
            viewModel.quoteItems = [QuoteItems(item: "Test Item", itemNote: "Test Note")]
            viewModel.reference = "REF123"
            viewModel.amount = 100.00
            viewModel.additionalNotes = "Test Notes"
            viewModel.customer = Customer(name: "Test Customer", email: "test@example.com", phoneNumber: "")
        }
        
        let quote = await viewModel.onTapSave()
        
        await MainActor.run {
            XCTAssertEqual(quote.items?.count, 1)
            XCTAssertEqual(quote.items?[0].item, "Test Item")
            XCTAssertEqual(quote.items?[0].itemNote, "Test Note")
            XCTAssertEqual(quote.reference, "REF123")
            XCTAssertEqual(quote.amount, 100.00)
            XCTAssertEqual(quote.notes, "Test Notes")
            XCTAssertEqual(quote.customer?.name, "Test Customer")
            XCTAssertEqual(quote.customer?.email, "test@example.com")
        }
    }
}
