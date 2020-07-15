//
//  Accident.swift
//  CarApp
//
//  Created by Liel Titelbaum on 11/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import Foundation

class Accident {
    var accidentKey = ""
    var user1: Dictionary<String, Any>
    var user2: Dictionary<String, Any>
    var accidentLocation:Location = Location()
    var accidentDate: String = ""
    var photos: Dictionary <String, String> //dictionary of string-> photoId, string->photoUrl
    
    var dict: [String:Any] = [:]
    
    init(user1: Dictionary<String, Any>, user2: Dictionary<String,Any>, accidentLocation: Location, photos: Dictionary<String, String> ) {
        let user1Key: String! = user1[DictKeyConstants.profileKeyId] as? String
        let user2Key: String! = user2[DictKeyConstants.profileKeyId] as? String
        self.accidentKey = user1Key + "_" + user2Key
        self.user1 = user1
        self.user2 = user2
        self.accidentLocation = accidentLocation
       let currentDate = Date()
        let formatterDate = DateFormatter()
        formatterDate.dateStyle = .long
        formatterDate.timeStyle = .short
        formatterDate.locale = .current
        self.accidentDate = formatterDate.string(from: currentDate)
        self.photos = photos
    }
    
    func convertToDict() -> Dictionary<String, Any> {
        dict = [DictKeyConstants.accidentKey: self.accidentKey, DictKeyConstants.accidentUser1:self.user1, DictKeyConstants.accidentUser2: self.user2, DictKeyConstants.accidentLocation: self.accidentLocation, DictKeyConstants.accidentDate: self.accidentDate, DictKeyConstants.accidentPhotos: self.photos]
        return dict
    }
    
    func setDate(date: String){
        self.accidentDate = date
    }
    
    private func setAccidentKey(key: String){
        self.accidentKey = key
    }
    
    static func convertDictToAccidentObj(dict: Dictionary<String, Any>) -> Accident {
        let accidentKey = dict[DictKeyConstants.accidentKey] as! String
        let user1 = dict[DictKeyConstants.accidentUser1] as! Dictionary<String, Any>
        let user2 = dict[DictKeyConstants.accidentUser2] as! Dictionary<String, Any>
        let location = dict[DictKeyConstants.accidentLocation] as! Location
        let date = dict[DictKeyConstants.accidentDate] as! String
        let photos = dict[DictKeyConstants.accidentPhotos] as! Dictionary <String, String>
        let accident: Accident = Accident(user1: user1, user2: user2, accidentLocation: location, photos: photos) //note: check if values are changing
        accident.setDate(date: date)
        accident.setAccidentKey(key: accidentKey)
        return accident
    }
    
//    func addPhoto(photo: String) {
//        photos.insert(photo)
//    }
//
//    func removePhoto(photo: String){
//        photos.remove(photo)
//    }
}
