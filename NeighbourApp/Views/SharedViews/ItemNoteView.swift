//
//  ItemNoteView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 20/7/2024.
//

import SwiftUI

struct ItemNoteView: View {
    @Binding var itemNote: String
    @Binding var isShown: Bool
    var body: some View {
        ZStack {
            TextEditor(text: $itemNote)
                .frame(width: 200, height: 40, alignment: .center)
                .border(.blue)
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isShown = false
                }
            } label: {
               Image(systemName: "checkmark.square.fill")
            }
            .offset(x: 80)
        }
    }
}

#Preview {
    ItemNoteView(itemNote: .constant("Something"), isShown: .constant(true))
}
