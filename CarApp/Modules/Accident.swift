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
    var user1Key: String = ""
    var user2Key: String = ""
    var accidentLocationLat: Double = 0
    var accidentLocationLong: Double = 0
    var accidentDate: String = ""
    var accidentPhotosKey: String = ""

    init(accidentKey: String, user1Key: String, user2Key: String, accidentLocationLat:Double, accidentLocationLong:Double, accidentPhotosKey: String) {
        self.accidentKey = accidentKey
        self.user1Key = user1Key
        self.user2Key = user2Key
        self.accidentLocationLat = accidentLocationLat
        self.accidentLocationLong = accidentLocationLong
        self.accidentPhotosKey = accidentPhotosKey
        let currentDate = Date()
        let formatterDate = DateFormatter()
        formatterDate.dateStyle = .long
        formatterDate.timeStyle = .short
        formatterDate.locale = .current
        self.accidentDate = formatterDate.string(from: currentDate)
    }
    
    init(accidentKey: String, user1Key: String, user2Key: String, accidentLocationLat:Double, accidentLocationLong:Double,accidentDate:String, accidentPhotosKey: String) {
           self.accidentKey = accidentKey
           self.user1Key = user1Key
           self.user2Key = user2Key
           self.accidentLocationLat = accidentLocationLat
           self.accidentLocationLong = accidentLocationLong
           self.accidentPhotosKey = accidentPhotosKey
           self.accidentDate = accidentDate
       }
    
    func convertToDict() -> Dictionary<String, Any> {
       return [DictKeyConstants.accidentKey: self.accidentKey, DictKeyConstants.accidentUser1:self.user1Key, DictKeyConstants.accidentUser2: self.user2Key, DictKeyConstants.accidentLocationLat: self.accidentLocationLat, DictKeyConstants.accidentLocationLong: self.accidentLocationLong, DictKeyConstants.accidentDate: self.accidentDate, DictKeyConstants.accidentPhotos: self.accidentPhotosKey]
    }
    
    static func convertDictToAccidentObj(dict: Dictionary<String, Any>) -> Accident {
        let accidentKey = dict[DictKeyConstants.accidentKey] as? String ?? ""
        let user1 = dict[DictKeyConstants.accidentUser1] as? String ?? ""
        let user2 = dict[DictKeyConstants.accidentUser2] as? String ?? ""
        let locationLat = dict[DictKeyConstants.accidentLocationLat] as? Double ?? 0
        let locationLong = dict[DictKeyConstants.accidentLocationLong] as? Double ?? 0
        let date = dict[DictKeyConstants.accidentDate] as? String ?? ""
        let photos = dict[DictKeyConstants.accidentPhotos] as? String ?? ""
       
        return Accident(accidentKey: accidentKey, user1Key: user1, user2Key: user2, accidentLocationLat: locationLat, accidentLocationLong: locationLong, accidentDate: date, accidentPhotosKey: photos)
    }
}
