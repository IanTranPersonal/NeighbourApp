//
//  Extensions.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 29/7/2024.
//

import Foundation

extension Optional where Wrapped == String {
    var valueIfNotEmpty: String? {
        guard let self = self?.trimmingCharacters(in: .whitespacesAndNewlines), !self.isEmpty else {
            return nil
        }
        return self
    }
}
