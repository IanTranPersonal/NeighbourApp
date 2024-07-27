//
//  SummaryView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 27/7/2024.
//

import SwiftUI

struct SummaryView: View {
    @EnvironmentObject var base: Base
    var body: some View {
        ZStack {
            Text("Summary")
                .offset(x: -100, y: -110)
                .foregroundColor(.gray)
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 200)
                .cornerRadius(8)
                .shadow(radius: 10)
            Text("\(quotes) Quotes")
            
            Text("\(current) Current Jobs")
                .offset(y: 20)
        }
        .onAppear(perform: {
            Task{ await base.retrieveData()}
        })
    }
    
    private var quotes: String {
        let allQuotes = base.quote
        let quotes = allQuotes.filter({$0.status == "quote"})
        return quotes.count.description
    }
    
    private var current: String {
        let allQuotes = base.quote
        let quotes = allQuotes.filter({$0.status == "deposit"})
        return quotes.count.description
    }
}

#Preview {
    SummaryView().environmentObject(Base())
}
