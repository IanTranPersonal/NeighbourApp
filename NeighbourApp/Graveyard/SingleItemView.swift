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
