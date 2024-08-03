//
//  PDFGeneratorTests.swift
//  NeighbourAppTests
//
//  Created by Vinh Tran on 28/7/2024.
//

import PDFKit
import XCTest
@testable import Invoicr

class PDFGeneratorTests: XCTestCase {
    
    var pdfGenerator: PDFGenerator!
    var mockQuote: Quote!
    var mockBackgroundPDFURL: URL!

    override func setUpWithError() throws {
        pdfGenerator = PDFGenerator.shared
        
        // Set up a mock Quote
        mockQuote = Quote(
            items: [QuoteItems(item: "Test Item", itemNote: "Test Item Note")],
            reference: "TEST001",
            amount: 1000.0,
            notes: "Test notes",
            customer: Customer(name: "Test Customer", email: "test@example.com", phoneNumber: ""),
            paidAmount: 500.0,
            total: 1000.0
        )
        
        // Create a mock background PDF URL
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        mockBackgroundPDFURL = URL(fileURLWithPath: documentsPath).appendingPathComponent("mockBackground.pdf")
        
        // Create a simple PDF file for testing
        let pdfContext = CGContext(mockBackgroundPDFURL as CFURL, mediaBox: nil, nil)
        pdfContext?.beginPDFPage(nil)
        pdfContext?.endPDFPage()
        pdfContext?.closePDF()
    }

    override func tearDownWithError() throws {
        pdfGenerator = nil
        mockQuote = nil
        
        // Clean up the mock PDF file
        try? FileManager.default.removeItem(at: mockBackgroundPDFURL)
    }

    func testGeneratePDF() {
        let pdfData = pdfGenerator.generatePDF(for: mockQuote, backgroundPDF: mockBackgroundPDFURL)
        
        XCTAssertNotNil(pdfData, "PDF data should not be nil")
        XCTAssert(pdfData!.count > 0, "PDF data should not be empty")
    }
    
    func testGeneratePDFWithInvalidBackgroundURL() {
        let invalidURL = URL(fileURLWithPath: "/invalid/path.pdf")
        let pdfData = pdfGenerator.generatePDF(for: mockQuote, backgroundPDF: invalidURL)
        
        XCTAssertNil(pdfData, "PDF data should be nil for invalid background URL")
    }
    
    func testSavePDF() {
        let testData = "Test PDF Content".data(using: .utf8)!
        let fileName = "testPDF"
        
        let savedURL = pdfGenerator.savePDF(data: testData, fileName: fileName)
        
        XCTAssertNotNil(savedURL, "Saved URL should not be nil")
        XCTAssertTrue(FileManager.default.fileExists(atPath: savedURL!.path), "PDF file should exist at the saved URL")
        
        // Clean up
        try? FileManager.default.removeItem(at: savedURL!)
    }
    
    func testSavePDFWithInvalidData() {
        let invalidData = Data()
        let fileName = "emptyPDF"
        
        let savedURL = pdfGenerator.savePDF(data: invalidData, fileName: fileName)
        
        XCTAssertNotNil(savedURL, "Saved URL should not be nil even for empty data")
        XCTAssertTrue(FileManager.default.fileExists(atPath: savedURL!.path), "Empty PDF file should still be created")
        
        // Clean up
        try? FileManager.default.removeItem(at: savedURL!)
    }
}
