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
import Photos
import UIKit
import AVFoundation

class FirebaseFunctions {
    
    static let db = Firestore.firestore()
    
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
    
    static func getCurrentUserUId() ->String {
        if isUserLoggedIn() {
            return Auth.auth().currentUser?.uid ?? ""
        }
        else {
            logIn()
            return ""
        }
    }
    
    static func createEmptyAccidentsImagesInFirestore (accidentKey: String) {
        //create new images for this accidentKey, this function create the path and insert defult vaules at the first time the accident is created, until it will be edited.
        let images = [DictKeyConstants.accidentImagesDbUploaded: "emptyUrl", DictKeyConstants.accidentImagesUrl : ""]//defult values until users will insert images from the accident
        
        db.collection(Constants.fireStoreDbImagesAccident).document(accidentKey).setData(images) { (error) in
            if error != nil {
                //print error
                print("Error creating accident images path in firestore")
            }
        }
    }
    
    static func createAccidentInFirestore(accident: Accident){
        db.collection(Constants.fireStoreDbAccident).document(accident.accidentKey).setData(accident.convertToDict()) { (error) in
            if error != nil {
                //print error
                print("Error creating accident path in firestore")
            }
        }
        createEmptyAccidentsImagesInFirestore(accidentKey: accident.accidentKey)
    }
    
    static func getAccidentsFromFirebase(accidentKey: String) -> Dictionary<String, Any> {
        //        db.collection(Constants.fireStoreDbAccident).addSnapshotListener { (querySnapshot, error) in
        //            guard let documents = querySnapshot?.documents else {
        //                print("No documents")
        //                return
        //            }
        //            var accidents = documents.map { (queryDocumentSnapshot) -> Accident in
        //                let data = queryDocumentSnapshot.data()
        //
        //                let accidentDate =
        //            }
        //        }
        var dict:Dictionary<String, Any> = [:]
        db.collection(Constants.fireStoreDbAccident).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    dict.updateValue(document.data(), forKey: document.documentID)
                    print("\(document.documentID) => \(document.data())")
                }
            }
            
        }
        return dict
    }
    
    static func getImagesForAccidentFirebase(imagesKey: String) -> Dictionary<String, Any> {
        let imagesRef = db.collection(Constants.fireStoreDbImagesAccident)
        var dataDict :Dictionary<String, Any> = [:]
        
        if isUserLoggedIn() {
            let firebasePath = imagesRef.document(imagesKey)
            firebasePath.getDocument { (document, error) in
                if let document = document, document.exists {
                    dataDict = document.data()!
                    print("Document data: \(dataDict)")
                } else {
                    print("Document does not exist")
                }
            }
        }
        return dataDict
    }
    //
    static func uploadImageToFirestorage( childNameInStoragePath: String, imageName: String, imageData: Data) -> String{
        //upload imagr to fireStorage and returns its' url
        var urlReturn :String = ""
        let storageRef = Storage.storage().reference(forURL: Constants.firebaseStorageRefUrl)
        let storageImageRef = storageRef.child(childNameInStoragePath).child(imageName)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageImageRef.putData(imageData, metadata: metaData) { (storageMeteData, error) in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            storageImageRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    urlReturn = metaImageUrl
                }
            }
        }
        return urlReturn
    }
    
    static func updateValueInProfile(key: String, val: Any, userUID: String) {
        let userRef = db.collection(Constants.fireStoreDbUsers)
        
        userRef.document(userUID).updateData([key : val]) { (err) in
            if let err = err {
                print(err.localizedDescription)
            }
            print("Successfully updated data")
        }
    }
    
    static func addImageToAccidentsFirestore(imagesAccidentKey: String, imageUrl: String){
        //add new image to accident images by its' url and accident images key
        let accidentImages = db.collection(Constants.fireStoreDbImagesAccident)
        
        //set key and value to be image url
        accidentImages.document(imagesAccidentKey).setData([ imageUrl : imageUrl]) { (error) in
            if error != nil {
                //print error
                print("Error creating new accident image path in firestore")
            }
            
        }
    }
    
    static func getUserInfo(userUID: String) -> Dictionary<String, Any> {
        let usersRef = db.collection(Constants.fireStoreDbUsers)
        var dataDict :Dictionary<String, Any> = [:]
        
        let firebasePath = usersRef.document(userUID)
                firebasePath.getDocument { (document, error) in
                    if let document = document, document.exists {
                        dataDict = document.data()!
                        print("Document data: \(dataDict)")
                    } else {
                        print("Document does not exist")
                    }
                }
            return dataDict
    }
    
    static func getProfileInfo() -> Dictionary <String, Any> {
        var dataDict :Dictionary<String, Any> = [:]
        
        if isUserLoggedIn() {
            let userUID = Auth.auth().currentUser!.uid
            dataDict = getUserInfo(userUID: userUID)
        }
        return dataDict
    }
    
}
