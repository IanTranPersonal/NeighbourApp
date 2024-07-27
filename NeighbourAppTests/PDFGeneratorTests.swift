//
//  PDFGeneratorTests.swift
//  NeighbourAppTests
//
//  Created by Vinh Tran on 28/7/2024.
//

import XCTest
import PDFKit
@testable import NeighbourApp

class PDFGeneratorTests: XCTestCase {
    
    var pdfGenerator: PDFGenerator!
    
    override func setUp() {
        super.setUp()
        pdfGenerator = PDFGenerator.shared
    }
    
    override func tearDown() {
        pdfGenerator = nil
        super.tearDown()
    }
    
    func testSharedInstance() {
        XCTAssertNotNil(PDFGenerator.shared)
        XCTAssert(PDFGenerator.shared === PDFGenerator.shared)
    }
    
    func testGeneratePDF() {
        // Create a mock Quote
        let mockQuote = Quote(
            id: "TEST123",
            items: [QuoteItems(item: "Test Item", itemNote: "Test Note")],
            reference: "REF123",
            status: "Pending",
            amount: 100.00,
            notes: "Test Notes",
            customer: Customer(name: "Test Customer", email: "test@example.com", phoneNumber: ""),
            paidAmount: 50.00,
            total: 100.00
        )
        
        // Create a mock URL for the background PDF
        let mockURL = Constants.pdfURL!
        
        // Generate PDF
        let pdfData = pdfGenerator.generatePDF(for: mockQuote, backgroundPDF: mockURL)
        
        // Assert that PDF data is generated
        XCTAssertNotNil(pdfData)
        
        // Create a PDFDocument from the generated data to verify its content
        if let pdfData = pdfData, let generatedPDF = PDFDocument(data: pdfData) {
            XCTAssertGreaterThan(generatedPDF.pageCount, 0)
            
            // You can add more specific checks here, such as verifying text content
            // This would require extracting text from the PDF, which is beyond the scope of this example
        } else {
            XCTFail("Failed to create PDFDocument from generated data")
        }
    }
    
    func testSavePDF() {
        let testData = "Test PDF Content".data(using: .utf8)!
        let fileName = "TestPDF"
        
        let savedURL = pdfGenerator.savePDF(data: testData, fileName: fileName)
        
        XCTAssertNotNil(savedURL)
        XCTAssertTrue(savedURL?.lastPathComponent == "\(fileName).pdf")
        
        // Verify that the file exists
        if let url = savedURL {
            XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
            
            // Verify file content
            let savedData = try? Data(contentsOf: url)
            XCTAssertEqual(savedData, testData)
            
            // Clean up: delete the test file
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    func testGeneratePDFWithInvalidBackgroundURL() {
        let mockQuote = Quote(id: "TEST123", items: [], reference: "REF123", status: "Pending", amount: 100.00, notes: nil, customer: nil, paidAmount: 0, total: 100.00)
        let invalidURL = URL(fileURLWithPath: "/invalid/path/to/background.pdf")
        
        let pdfData = pdfGenerator.generatePDF(for: mockQuote, backgroundPDF: invalidURL)
        
        XCTAssertNil(pdfData)
    }
}
