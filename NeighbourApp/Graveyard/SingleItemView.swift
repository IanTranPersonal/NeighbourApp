//
//  SingleItemView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 20/7/2024.
//

//import SwiftUI
//
//struct SingleItemView: View {
//    var selections = Constants.items.map{$0.item}
//    @Binding var item: String
//    @Binding var itemNote: String
//    @State var showNote: Bool = false
//    var body: some View {
//        HStack {
//            Spacer()
//            Picker("", selection: $item) {
//                ForEach(selections, id: \.self) {
//                    Text($0)
//                }
//            }
//            
//            Spacer()
//            Button {
//                withAnimation(.easeInOut(duration: 0.5)){
//                    showNote.toggle()
//                }
//            } label: {
//                Image(systemName: "pencil.circle")
//            }
//            Spacer()
//        }
//        if showNote {
//            ItemNoteView(itemNote: $itemNote, isShown: $showNote)
//        }
//        
//    }
//}
//
//#Preview {
//    SingleItemView(item: .constant("Item"), itemNote: .constant("None"))
//}


//
//  PDFGeneratorTests.swift
//  NeighbourAppTests
//
//  Created by Vinh Tran on 28/7/2024.
//

//import XCTest
//import PDFKit
//@testable import Invoicr
//
//class PDFGeneratorTests: XCTestCase {
//    
//    var pdfGenerator: PDFGenerator!
//    var mockQuote: Quote!
//    var mockBackgroundPDFURL: URL!
//    let fileManager = FileManager.default
//
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        pdfGenerator = PDFGenerator.shared
//        
//        // Set up a mock Quote
//        mockQuote = Quote(items: [QuoteItems(item: "Test Item", itemNote: "Test Item Note")],
//                          reference: "TEST001",
//                          amount: 1000.0,
//                          notes: "Test notes",
//                          customer: Customer(name: "Test Customer", email: "test@example.com", phoneNumber: ""),
//                          paidAmount: 500.0,
//                          total: 1000.0)
//        
//        // Create a mock background PDF URL in the temporary directory
//        let tempDir = fileManager.temporaryDirectory
//        mockBackgroundPDFURL = tempDir.appendingPathComponent("mockBackground.pdf")
//        
//        // Create a simple PDF file for testing
//        try createMockPDF(at: mockBackgroundPDFURL)
//    }
//
//    override func tearDownWithError() throws {
//        pdfGenerator = nil
//        mockQuote = nil
//        
//        // Clean up the mock PDF file
//        try? fileManager.removeItem(at: mockBackgroundPDFURL)
//        
//        try super.tearDownWithError()
//    }
//
//    func createMockPDF(at url: URL) throws {
//        UIGraphicsBeginPDFContextToFile(url.path, .zero, nil)
//        UIGraphicsBeginPDFPage()
//        UIGraphicsEndPDFContext()
//    }
//
//    func testGeneratePDF() throws {
//        let expectation = XCTestExpectation(description: "Generate PDF")
//        
//        DispatchQueue.global().async {
//            let pdfData = self.pdfGenerator.generatePDF(for: self.mockQuote, backgroundPDF: self.mockBackgroundPDFURL)
//            
//            XCTAssertNotNil(pdfData, "PDF data should not be nil")
//            XCTAssert(pdfData!.count > 0, "PDF data should not be empty")
//            
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: 5.0)
//    }
//    
//    func testGeneratePDFWithInvalidBackgroundURL() throws {
//        let invalidURL = URL(fileURLWithPath: "/invalid/path.pdf")
//        let pdfData = pdfGenerator.generatePDF(for: mockQuote, backgroundPDF: invalidURL)
//        
//        XCTAssertNil(pdfData, "PDF data should be nil for invalid background URL")
//    }
//    
//    func testSavePDF() throws {
//        let testData = "Test PDF Content".data(using: .utf8)!
//        let fileName = "testPDF"
//        
//        let savedURL = pdfGenerator.savePDF(data: testData, fileName: fileName)
//        
//        XCTAssertNotNil(savedURL, "Saved URL should not be nil")
//        XCTAssertTrue(fileManager.fileExists(atPath: savedURL!.path), "PDF file should exist at the saved URL")
//        
//        // Verify file content
//        let savedData = try Data(contentsOf: savedURL!)
//        XCTAssertEqual(savedData, testData, "Saved data should match the original data")
//        
//        // Clean up
//        try? fileManager.removeItem(at: savedURL!)
//    }
//    
//    func testSavePDFWithInvalidData() throws {
//        let invalidData = Data()
//        let fileName = "emptyPDF"
//        
//        let savedURL = pdfGenerator.savePDF(data: invalidData, fileName: fileName)
//        
//        XCTAssertNotNil(savedURL, "Saved URL should not be nil even for empty data")
//        XCTAssertTrue(fileManager.fileExists(atPath: savedURL!.path), "Empty PDF file should still be created")
//        
//        // Verify file content
//        let savedData = try Data(contentsOf: savedURL!)
//        XCTAssertEqual(savedData, invalidData, "Saved data should be empty")
//        
//        // Clean up
//        try? fileManager.removeItem(at: savedURL!)
//    }
//}
