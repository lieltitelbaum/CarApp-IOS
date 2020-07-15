//
//  FirebaseFunctions.swift
//  CarApp
//
//  Created by Liel Titelbaum on 12/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseFunctions {
    
    static func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    static func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out error")
        }
    }
    
    static func logIn () {
        
    }
    
    static func getAccidentList() {
        
    }
    
    
    static func updateValueInProfile(key: String, val: Any, path: String) {
        
    }
    
    static func getProfileInfo() {
        
    }
    
    static func getAllUsers() {
        
    }
    
    static func saveImageToFireStore(imageUrl: String,key: String, folderNameFireStorage: String) {
        
    }
}
