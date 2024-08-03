//
//  EmailFormatter.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 31/7/2024.
//

import SwiftUI

public final class EmailFormatter: Formatter {

    public override func string(for obj: Any?) -> String? {
        guard let string = obj as? String,
              isValidEmail(string)
        else { return "" }
        return string
    }

    public override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool
    {
        obj?.pointee = string as AnyObject
        return true
    }

    private func isValidEmail(_ string: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: string)
    }
}

import Combine

struct EmailTextField: View {
    @Binding var email: String
    @State private var isEmailValid = true
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .onChange(of: email) { newValue in
                    validateEmail(newValue)
                }
            
            if !isEmailValid {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
    
    private func validateEmail(_ email: String) {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        isEmailValid = emailPredicate.evaluate(with: email)
        
        if email.isEmpty {
            errorMessage = "Email is required"
        } else if !isEmailValid {
            errorMessage = "Please enter a valid email address"
        } else {
            errorMessage = ""
        }
    }
}
