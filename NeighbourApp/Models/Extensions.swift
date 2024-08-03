//
//  Extensions.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 29/7/2024.
//

import Foundation
import SwiftUI
import RegexBuilder

extension Optional where Wrapped == String {
    var valueIfNotEmpty: String? {
        guard let self = self?.trimmingCharacters(in: .whitespacesAndNewlines), !self.isEmpty else {
            return nil
        }
        return self
    }
}

extension String {
    var isValidEmail: Bool {
        let emailFormat = Regex {
            OneOrMore {
                CharacterClass(
                    .anyOf("._%$+-"),
                    ("A"..."Z"),
                    ("0"..."9"),
                    ("a"..."z")
                )
            }
            "@"
            OneOrMore {
                CharacterClass(
                    .anyOf(".-"),
                    ("A"..."Z"),
                    ("a"..."z"),
                    ("0"..."9")
                )
            }
            "."
            Repeat(2...64) {
                CharacterClass(
                    ("A"..."Z"),
                    ("a"..."z")
                )
            }
        }
        return self.wholeMatch(of: emailFormat) != nil
    }
}

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
    
    static var forestGreen = Color(hex: "#175616")
    
    static var customYellow = Color(hex: "#ffbc4d")
    
    static var deepBlue = Color(hex: "#0c2168")
    
    static var middleBlue = Color(hex: "#364fa5")
    
    static var skyBlue = Color(hex: "#a6e3f1")
    
    static var otherBlue = Color(hex: "#daeff4")
    
    static var federalBlue = Color(hex: "#031A6B")
    static var prussianBlue = Color(hex: "#033860")
    static var cerulean = Color(hex: "#087CA7")
    static var polynesianBlue = Color(hex: "#004385")
    static var aeroBlue = Color(hex: "#05B2DC")
    static var indigoDye = Color(hex: "#133C55")
    static var biceBlue = Color(hex: "#386FA4")
    static var pictonBlue = Color(hex: "#59A5D8")
    static var paleAzure = Color(hex: "84d2f6")
    static var nonPhotoBlue = Color(hex: "#91E5F6")
    static var powderBlue = Color(hex: "#B4CDED")
}

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
