//
//  QuoteNoteView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 19/7/2024.
//

import SwiftUI

struct QuoteNoteView: View {
    @Binding var note: String
    @Binding var isPresented: Bool
    var body: some View {
        VStack {
            Text("Notes")
            TextEditor(text: $note)
                .frame(width: UIScreen.main.bounds.width - 100, height: 200)
                .border(.blue)
            Button("Done") {
                isPresented = false
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    QuoteNoteView(note: .constant("True"), isPresented: .constant(true))
}
