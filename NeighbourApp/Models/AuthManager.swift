//
//  AuthManager.swift
//  NeighbourApp
//
//  Created by Vinh Tran on 1/8/2024.
//

import FirebaseAuth
import Foundation

class AuthManager: ObservableObject {
    @Published var user: User?
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        setupAuthListener()
    }
    
    func setupAuthListener() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.user = user
        }
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
