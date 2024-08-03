//
//  UserModel.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 29/7/2024.
//

import SwiftUI

class UserModel: ObservableObject {
    @AppStorage("user") private var userData: Data?
    @Published var user = UserData()
    
    static let instance = UserModel()
    
    static let emptyUser = UserData()
    
    var userLogo: UIImage?
    
    func saveChanges() {
        do {
            let data = try JSONEncoder().encode(user)
            userData = data
            print("User Saved")
        }
        catch {
            print("Encoding failed")
        }
    }
    
    func retrieveUser() {
        guard let data = userData else {
            return
        }
        do {
            user = try JSONDecoder().decode(UserData.self, from: data)
            print("User Loaded")
        }
        catch {
            print("User failed to load - using empty user")
            user = UserModel.emptyUser
        }
    }
    
    func logOutCalled() {
        userData = nil
    }
    
    var isValidForm: Bool {
        !user.name.isEmpty && !user.email.isEmpty && !user.businessName.isEmpty && !user.bsb.isEmpty && !user.accNo.isEmpty
    }
}

struct UserData: Codable, Equatable {
    var name: String = ""
    var email: String = ""
    var businessName: String = ""
    var abn: String = ""
    var bsb: String = ""
    var accNo: String = ""
}

extension UserModel {
    static func grabUser() -> UserData {
        do {
            guard let userData = UserDefaults.standard.data(forKey: "user") else { return UserModel.emptyUser }
            let decoded = try JSONDecoder().decode(UserData.self, from: userData)
            return decoded
        }
        catch {
            return UserModel.emptyUser
        }
    }
}
