//
//  SingleCustomItemView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 20/7/2024.
//

import SwiftUI

struct SingleCustomItemView: View {
    @Binding var item: String
    @Binding var itemNote: String
    @State var showNote: Bool = false
    var placeholderString: String = "New Item"
    var body: some View {
        HStack{
            TextEditor(text: $item)
                .foregroundColor(self.item == placeholderString ? .gray : .primary)
                .onTapGesture {
                  if self.item == placeholderString {
                    self.item = ""
                  }
                }
                .frame(width: 180, height:  40, alignment: .center)
                .border(.gray)
            
            Spacer()
            Button {
                withAnimation(.easeInOut(duration: 0.5)){
                    showNote.toggle()
                }
            } label: {
                Image(systemName: "pencil.circle")
            }
        }
        if showNote {
            ItemNoteView(itemNote: $itemNote, isShown: $showNote)
        }
        
    }
    
}

#Preview {
    SingleCustomItemView(item: .constant("Item"), itemNote: .constant("None"))
}
