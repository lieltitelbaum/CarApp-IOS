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
    
    private static let db = Firestore.firestore()
    typealias CompletionAccidentList = (_ accidents : [Accident]?) -> Void
    typealias dict = Dictionary<String, Any>?
    
    public static func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    public static func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out error")
        }
    }
    
    public static func getCurrentUserUId() ->String {
        if isUserLoggedIn() {
            return Auth.auth().currentUser?.uid ?? ""
        }
        else {
            return ""
        }
    }
    
    public static func createEmptyAccidentsImagesInFirestore (accidentKey: String) {
        //create new images for this accidentKey, this function create the path and insert defult vaules at the first time the accident is created, until it will be edited.
        let images = [DictKeyConstants.accidentImagesUrl : "emptyURl"]//defult values until users will insert images from the accident
        
        db.collection(Constants.fireStoreDbImagesAccident).document(accidentKey).setData(images) { (error) in
            if error != nil {
                //print error
                print("Error creating accident images path in firestore")
            }
        }
    }
    
    public static func createAccidentInFirestore(accident: Accident){
        db.collection(Constants.fireStoreDbAccident).document(accident.accidentKey).setData(accident.convertToDict()) { (error) in
            if error != nil {
                //print error
                print("Error creating accident path in firestore")
            }
        }
        createEmptyAccidentsImagesInFirestore(accidentKey: accident.accidentKey)
    }
    
    public static func getAccidentFromFirebaseByKey(accidentKey: String, callback: @escaping (_ dict: Dictionary< String, Any>) -> ()) {
        //        return dict
        var dataDict :Dictionary<String, Any> = [:]
        //          let accidentRef = db.collection(Constants.fireStoreDbAccident)
        let firebasePath = db.collection(Constants.fireStoreDbAccident).document(accidentKey)
        firebasePath.getDocument { (document, error) in
            if let document = document, document.exists {
                dataDict = document.data()!
                print("accident dic info \(dataDict)")
                //                              print("Document data: \(dataDict)")
                callback(dataDict)
            } else {
                print("Document does not exist")
                callback(dataDict)
            }
        }
    }
    
    public static func getAllAccidentsFromFirebase(callBack: @escaping CompletionAccidentList) {
        //get accidents for current usre loged in
        var accidentsList = [Accident] ()
        db.collection(Constants.fireStoreDbAccident).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if(document.documentID.contains(getCurrentUserUId())) {
                        print("\(document.documentID) => \(document.data())")
                        accidentsList.append(Accident.convertDictToAccidentObj(dict: document.data()))
                    }
                    
                }
                callBack(accidentsList)
            }
            callBack(nil)
        }
    }
    
    public static func getImagesForAccidentFirebase(imagesKey: String, callBack: @escaping (_ dict: dict) -> ()) {
        //get all images for imageskey
        let imagesRef = db.collection(Constants.fireStoreDbImagesAccident).document(imagesKey)
        var dataDict :Dictionary<String, Any> = [:]
        
        if isUserLoggedIn() {
            imagesRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    dataDict = document.data()!
                    callBack(dataDict)
                    print("Document data: \(dataDict)")
                } else {
                    print("Document does not exist")
                    callBack(dataDict)
                }
            }
        }
    }
    
    public static func uploadImageToFirestorage( childNameInStoragePath: String, imageName: String, imageData: Data, callBack: @escaping (_ url : String) -> ()){
        //upload imagr to fireStorage and returns its' url
        var urlReturn :String = ""
        let storageRef = Storage.storage().reference(forURL: Constants.firebaseStorageRefUrl).child(childNameInStoragePath).child(imageName)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { (storageMeteData, error) in
            if error != nil{
                print(error!.localizedDescription)
                callBack("empty")
            }
            storageRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    urlReturn = metaImageUrl
                    print("metaImageUrl \(metaImageUrl)")
                    callBack(metaImageUrl)
                }
            }
        }
        print("url in firebase func: \(urlReturn)")
        
    }
    
    public static func updateValueInProfile(key: String, val: Any, userUID: String) {
        //update user profile by userUId, -> [key] = val
        let userRef = db.collection(Constants.fireStoreDbUsers)
        
        userRef.document(userUID).updateData([key : val]) { (err) in
            if let err = err {
                print(err.localizedDescription)
            }
            print("Successfully updated data")
        }
    }
    
    public static func addImageToAccidentsFirestore(imagesAccidentKey: String, imageUrl: String, callBack: @escaping (_ didFinsihUpload: Bool) -> ()){
        //add new image to accident images by its' url and accident images key
        let accidentImages = db.collection(Constants.fireStoreDbImagesAccident)
        
        //set key and value to be image url
        accidentImages.document(imagesAccidentKey).setData([UUID().uuidString : imageUrl], merge: true) { (error) in
            if error != nil {
                //print error
                print("Error creating new accident image path in firestore")
                callBack(false)
            }
            callBack(true)
        }
    }
    
   public static func getUserInfo(userUID: String, callBack: @escaping (_ dict: dict) -> ()) {
    //get user profile by his\her userUID and return its' dictionary in a call back when completed
        let usersRef = db.collection(Constants.fireStoreDbUsers).document(userUID)
        var dataDict :Dictionary<String, Any> = [:]
        
        usersRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                dataDict = document.data()!
                callBack(dataDict)
                
                print("Data dict:: \(dataDict)")
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
                callBack(dataDict)
            }
        }
    }
}
