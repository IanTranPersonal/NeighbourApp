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
        ZStack(alignment: .leading) {
            Text("Summary")
                .offset(y: -90)
                .foregroundColor(.gray)
                .bold()
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 150)
                .cornerRadius(8)
                .shadow(radius: 10)
            Text("\(quotes) Quotes")
                .offset(x: 10,y: -30)
                .foregroundColor(.blue)
                .font(.title3)
                .bold()
            
            Text("\(current) Current Jobs")
                .offset(x: 10, y: 0)
                .foregroundColor(.orange)
                .font(.title3)
                .bold()
            
            Text("\(paid) Completed Jobs")
                .offset(x: 10, y: 30)
                .foregroundColor(.green)
                .font(.title3)
                .bold()
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
    
    private var paid: String {
        let allQuotes = base.quote
        let paid = allQuotes.filter({$0.status == "paid"})
        return paid.count.description
    }
}

#Preview {
    SummaryView().environmentObject(Base())
}
