//
//  ExistingQuoteTests.swift
//  NeighbourAppTests
//
//  Created by Vinh Tran on 28/7/2024.
//

import XCTest
@testable import NeighbourApp

class ExistingQuoteViewModelTests: XCTestCase {
    
    var viewModel: ExistingQuoteViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ExistingQuoteViewModel(
            id: "TEST123",
            quoteItems: [QuoteItems(item: "Test Item", itemNote: "Test Note")],
            price: 100.00,
            status: "quote",
            reference: "REF123",
            notes: "Test Notes",
            customer: Customer(name: "Test Customer", email: "test@example.com", phoneNumber: ""),
            paidAmount: 50.00,
            total: 100.00
        )
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertEqual(viewModel.id, "TEST123")
        XCTAssertEqual(viewModel.quoteItems.count, 1)
        XCTAssertEqual(viewModel.quoteItems[0].item, "Test Item")
        XCTAssertEqual(viewModel.quoteItems[0].itemNote, "Test Note")
        XCTAssertEqual(viewModel.price, 100.00)
        XCTAssertEqual(viewModel.status, "quote")
        XCTAssertEqual(viewModel.reference, "REF123")
        XCTAssertEqual(viewModel.notes, "Test Notes")
        XCTAssertEqual(viewModel.customer.name, "Test Customer")
        XCTAssertEqual(viewModel.customer.email, "test@example.com")
        XCTAssertEqual(viewModel.paidAmount, 50.00)
        XCTAssertEqual(viewModel.total, 100.00)
    }
    
    func testQuoteProperty() {
        let quote = viewModel.quote
        XCTAssertEqual(quote.id, "TEST123")
        XCTAssertEqual(quote.items?.count, 1)
        XCTAssertEqual(quote.items?[0].item, "Test Item")
        XCTAssertEqual(quote.items?[0].itemNote, "Test Note")
        XCTAssertEqual(quote.reference, "REF123")
        XCTAssertEqual(quote.status, "quote")
        XCTAssertEqual(quote.amount, 100.00)
        XCTAssertEqual(quote.notes, "Test Notes")
        XCTAssertEqual(quote.customer?.name, "Test Customer")
        XCTAssertEqual(quote.customer?.email, "test@example.com")
        XCTAssertEqual(quote.paidAmount, 50.00)
        XCTAssertEqual(quote.total, 100.00)
    }
    
    func testAddItem() {
        XCTAssertEqual(viewModel.quoteItems.count, 1)
        
        viewModel.addItem()
        
        XCTAssertEqual(viewModel.quoteItems.count, 2)
        XCTAssertEqual(viewModel.quoteItems[1].item, "New Item")
        XCTAssertEqual(viewModel.quoteItems[1].itemNote, "")
    }
    
    func testShareItemForQuote() {
        // Mock PDFGenerator
        let mockPDFGenerator = MockPDFGenerator()
        PDFGenerator.shared = mockPDFGenerator
        
        let result = viewModel.shareItem()
        
        XCTAssertEqual(mockPDFGenerator.generatedQuote?.id, "TEST123")
        XCTAssertEqual(mockPDFGenerator.savedFileName, "Quote-REF123")
    }
    
    func testShareItemForInvoice() {
        viewModel.status = "invoice"
        
        // Mock PDFGenerator
        let mockPDFGenerator = MockPDFGenerator()
        PDFGenerator.shared = mockPDFGenerator
        
        let result = viewModel.shareItem()
        
        XCTAssertEqual(mockPDFGenerator.generatedQuote?.id, "TEST123")
        XCTAssertEqual(mockPDFGenerator.savedFileName, "Invoice-REF123")
    }
    
    func testShareItemFailedPDFGeneration() {
        let mockPDFGenerator = MockPDFGenerator()
        mockPDFGenerator.shouldFailPDFGeneration = true
        PDFGenerator.shared = mockPDFGenerator
        
        let result = viewModel.shareItem()
        
        XCTAssertEqual(result, Constants.quoteURL)
    }
    
    func testShareItemFailedPDFSaving() {
        let mockPDFGenerator = MockPDFGenerator()
        mockPDFGenerator.shouldFailPDFSaving = true
        PDFGenerator.shared = mockPDFGenerator
        
        let result = viewModel.shareItem()
        
        XCTAssertEqual(result, Constants.quoteURL)
    }
}

// Mock PDFGenerator for testing
class MockPDFGenerator: PDFGenerator {
    var generatedQuote: Quote?
    var savedFileName: String?
    var shouldFailPDFGeneration = false
    var shouldFailPDFSaving = false
    
    override func generatePDF(for quote: Quote, backgroundPDF: URL) -> Data? {
        if shouldFailPDFGeneration {
            return nil
        }
        generatedQuote = quote
        return Data()
    }
    
    override func savePDF(data: Data, fileName: String) -> URL? {
        if shouldFailPDFSaving {
            return nil
        }
        savedFileName = fileName
        return URL(string: "https://example.com/\(fileName).pdf")
    }
}
