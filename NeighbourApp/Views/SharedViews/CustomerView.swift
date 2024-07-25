//
//  CustomerView.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 21/7/2024.
//

import SwiftUI

struct CustomerView: View {
    @Binding var name: String
    @Binding var email: String
    @Binding var phoneNumber: String
    @Binding var isShowing: Bool
    var body: some View {
        Form {
            Section(header: Text("Customer Details")) {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                TextField("Contact Number", text: $phoneNumber)
            }
            Section {
                Button("Save") {
                    withAnimation(.linear){
                        isShowing = false
                    }
                }
            }
        }
    }
}

#Preview {
    CustomerView(name: .constant("First Last"), email: .constant("email@email.com"), phoneNumber: .constant("0412345678"), isShowing: .constant(true))
}
