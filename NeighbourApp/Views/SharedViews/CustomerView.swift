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
        VStack {
            Form {
                Section(header: Text("Customer Details")) {
                    TextField("Name", text: $name)
                    TextField("Email", value: $email, formatter: EmailFormatter())
                                                .textInputAutocapitalization(.never)
                                                .textContentType(.emailAddress)
                                                .keyboardType(.emailAddress)
                                                .autocorrectionDisabled()
                    TextField("Contact Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
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
}

#Preview {
    CustomerView(name: .constant("First Last"), email: .constant("email@email.com"), phoneNumber: .constant("0412345678"), isShowing: .constant(true))
}
