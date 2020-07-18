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
import FirebaseStorage

class FirebaseFunctions {
    
    let db = Firestore.firestore()
    
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
    
  
//    static func uploadProfileImageToStorage(userUID: String, imageData: Data) ->String {
//        //return the image url from storage
//        let storageRef = Storage.storage().reference(forURL: Constants.firebaseStorageRefUrl)
//        let storageProfileRef = storageRef.child("profile").child(userUID)
//        
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpg"
//        storageProfileRef.putData(imageData, metadata: metaData) { (storageMeteData, error) in
//            if error != nil{
//                print(error?.localizedDescription)
//                return
//            }
//            storageProfileRef.downloadURL { (url, error) in
//                if let metaImageUrl = url?.absoluteString {
//                    return metaImageUrl
//                }
//            }
//        }
//    }
    
    static func updateValueInProfile(key: String, val: Any, userUID: String) {
        let userRef = Firestore.firestore().collection(Constants.FIRE_STORE_DB_PATH)
        
        userRef.document(userUID).updateData([key : val]) { (err) in
            if let err = err {
                print(err.localizedDescription)
            }
            print("Successfully updated data")
        }
    }
    
    static func getProfileInfo() {
        
    }
    
    static func saveImageToFireStore(imageUrl: String,key: String, folderNameFireStorage: String) {
        
    }
}
