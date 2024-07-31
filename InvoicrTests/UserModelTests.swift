//
//  UserModelTests.swift
//  NeighbourAppTests
//
//  Created by Vinh Tran on 30/7/2024.
//

import Foundation
import XCTest
@testable import Invoicr

class UserModelTests: XCTestCase {
    
    var userModel: UserModel!
    
    override func setUp() {
        super.setUp()
        userModel = UserModel()
    }
    
    override func tearDown() {
        userModel = nil
        UserDefaults.standard.removeObject(forKey: "user")
        super.tearDown()
    }
    
    func testSaveChanges() {
        let testUser = UserData(name: "John Doe", email: "john@example.com", businessName: "ACME Corp", abn: "12345678901", bsb: "123-456", accNo: "78901234")
        userModel.user = testUser
        
        userModel.saveChanges()
        
        XCTAssertNotNil(UserDefaults.standard.data(forKey: "user"), "User data should be saved to UserDefaults")
    }
    
    func testRetrieveUser() {
        let testUser = UserData(name: "Jane Smith", email: "jane@example.com", businessName: "XYZ Ltd", abn: "98765432109", bsb: "987-654", accNo: "32109876")
        let encodedData = try? JSONEncoder().encode(testUser)
        UserDefaults.standard.set(encodedData, forKey: "user")
        
        userModel.retrieveUser()
        
        XCTAssertEqual(userModel.user.name, testUser.name)
        XCTAssertEqual(userModel.user.email, testUser.email)
        XCTAssertEqual(userModel.user.businessName, testUser.businessName)
        XCTAssertEqual(userModel.user.abn, testUser.abn)
        XCTAssertEqual(userModel.user.bsb, testUser.bsb)
        XCTAssertEqual(userModel.user.accNo, testUser.accNo)
    }
    
    func testRetrieveUserWithInvalidData() {
        UserDefaults.standard.set("Invalid Data", forKey: "user")
        
        userModel.retrieveUser()
        
        XCTAssertEqual(userModel.user, UserModel.emptyUser)
    }
    
    func testIsValidForm() {
        userModel.user = UserData(name: "Alice", email: "alice@example.com", businessName: "Alice's Shop", abn: "11223344556", bsb: "112-233", accNo: "44556677")
        XCTAssertTrue(userModel.isValidForm)
        
        userModel.user.name = ""
        XCTAssertFalse(userModel.isValidForm)
        
        userModel.user.name = "Alice"
        userModel.user.email = ""
        XCTAssertFalse(userModel.isValidForm)
    }
    
    func testGrabUser() {
        let testUser = UserData(name: "Bob", email: "bob@example.com", businessName: "Bob's Store", abn: "55667788990", bsb: "556-677", accNo: "88990011")
        let encodedData = try? JSONEncoder().encode(testUser)
        UserDefaults.standard.set(encodedData, forKey: "user")
        
        let retrievedUser = UserModel.grabUser()
        
        XCTAssertEqual(retrievedUser, testUser)
    }
    
    func testGrabUserWithNoData() {
        UserDefaults.standard.removeObject(forKey: "user")
        
        let retrievedUser = UserModel.grabUser()
        
        XCTAssertEqual(retrievedUser, UserModel.emptyUser)
    }
}
