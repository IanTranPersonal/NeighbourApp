//
//  PDFGeneratorModel.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 25/7/2024.
//

import SwiftUI
import PDFKit

class PDFGenerator {
    static let shared = PDFGenerator()
    
    func generatePDF(for quote: Quote, backgroundPDF: URL) -> Data? {
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 50
        let contentWidth = pageWidth - 2 * margin
        let contentHeight = pageHeight - 2 * margin
    
        guard let backgroundPDF = PDFDocument(url: backgroundPDF) else {
            return nil
        }
    
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
    
        let data = pdfRenderer.pdfData { context in
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .paragraphStyle: NSMutableParagraphStyle()
            ]
    
            for i in 0..<backgroundPDF.pageCount {
                guard let page = backgroundPDF.page(at: i), let cgPage = page.pageRef else { continue }
    
                context.beginPage()
                let pdfContext = context.cgContext
                pdfContext.saveGState()
                pdfContext.translateBy(x: 0, y: pageHeight)
                pdfContext.scaleBy(x: 1, y: -1)
    
                pdfContext.drawPDFPage(cgPage)
                pdfContext.restoreGState()
                
                // Stringify
                let referenceText = quote.reference ?? ""
                let amountText = String(quote.amount?.formatted(.currency(code: "AUD")) ?? "To be advised")
                let notesText = quote.notes ?? ""
                let customerText = quote.customer.map {$0.name + "\n" +  $0.email} ?? ""
                let exGSTAmount = String(((quote.amount ?? 0) * 0.9).formatted(.currency(code: "AUD")))
                let gstAmount = String(((quote.amount ?? 0) * 0.1).formatted(.currency(code: "AUD")))
                
                // Add content on top of the background PDF
                let properties = [
                    "\(Date().formatted(date: .numeric, time: .omitted))",
                    customerText,
                    referenceText,
                    "Notes: \(quote.notes ?? "None")",
                    amountText,
                    exGSTAmount,
                    gstAmount
                ]
                // Reminder: X is L-R, Y is U-D
                let positions: [CGPoint] = [
                    CGPoint(x: margin + 10, y: margin + 100), // Date
                    CGPoint(x: margin + 375, y: margin + 85), // Customer
                    CGPoint(x: margin + 10, y: margin + 132), // Reference
                    CGPoint(x: margin + 5, y: margin + 550), // Notes
                    CGPoint(x: margin + 438, y: margin + 585), // Amount
                    CGPoint(x: margin + 438, y: margin + 540), // Ex GST
                    CGPoint(x: margin + 438, y: margin + 560) // GST
                ]
    
                for (index, property) in properties.enumerated() {
                    let attributedString = NSAttributedString(string: property, attributes: textAttributes)
                    attributedString.draw(in: CGRect(x: positions[index].x, y: positions[index].y, width: contentWidth, height: pageHeight))
                }
                
                let items = quote.items?.compactMap {$0} .map {$0.item + "\n" + $0.itemNote + "\n"}
                guard let items else { continue }
                for (index, item) in items.enumerated() {
                    let marginMultiplier = CGFloat(index * 20)
                    let itemString = NSAttributedString(string: item, attributes: textAttributes)
                    itemString.draw(in: CGRect(x: margin + 10, y: margin + 300 + marginMultiplier, width: contentWidth, height: pageHeight))
                }
                
                if let paidAmount = quote.paidAmount, paidAmount > 0 {
                    let paidAmountString = "Paid amount: \(String(paidAmount.formatted(.currency(code: "AUD"))))"
                    let paidString = NSAttributedString(string: paidAmountString, attributes: textAttributes)
                    paidString.draw(in: CGRect(x: margin + 360, y: margin + 520, width: contentWidth, height: pageHeight))
                }
            }
            
        }
    
        return data
    }
    
    func savePDF(data: Data, fileName: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = documentDirectory.appendingPathComponent("\(fileName).pdf")
    
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Error saving PDF: \(error.localizedDescription)")
            return nil
        }
    }
}
