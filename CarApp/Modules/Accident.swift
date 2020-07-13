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
    var user1: Profile = Profile()
    var user2: Profile = Profile()
    var accidentLocation:Location = Location()
    var accidentDate: String = ""
    var photos: Set = Set<String>()
    
    init(user1: Profile, user2: Profile, accidentLocation: Location, photos: Set<String>) {
        self.accidentKey = user1.getUserKeyId() + "_" + user2.getUserKeyId()
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
    
    func addPhoto(photo: String) {
        photos.insert(photo)
    }
    
    func removePhoto(photo: String){
        photos.remove(photo)
    }
}
