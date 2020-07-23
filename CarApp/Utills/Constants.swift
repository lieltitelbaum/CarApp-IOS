//
//  Constants.swift
//  CarApp
//
//  Created by Liel Titelbaum on 09/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import Foundation

class Constants {
    static let fireStoreDbUsers = "users"
    static let homeViewController = "homeVC"
    static let loginRegisterViewController = "loginRegVC"
    static let scanViewController = "scanVC"
    static let firebaseStorageRefUrl = "gs://car-app-ios.appspot.com"
    static let moveToAccidentInfoVc = "detailsVC"
    static let fireStoreDbAccident = "accidents"
    static let fireStoreDbImagesAccident = "accidentImages"
    static let accidentDetailsFromScanBtn = "barcodeDetailsVc"
    static let accidentDetailsFromDemoBtn = "demoDetailsVc"
    static let accidentImagesFireStorageRef = "accidents"
    static let profileImageFireStorageRef = "profile"
    static let accidentInfoToAddImageVc = "infoToAddVc"
    static let accidentInfoToImageDetVc = "infoToDetailImgVc"
    static let otherDriverInfoVc = "otherDriverVc"
}

class DictKeyConstants {
    static let profileKeyId:String = "keyId"
    static let profileFirstName:String = "firstName"
    static let profileLastName:String = "lastName"
    static let profileEmail:String = "email"
    static let profilePhoneNumber:String = "phoneNumber"
    static let profileUserID:String = "userID"
    static let profileCarNumber:String = "carNumber"
    static let profileCarModel:String = "carModel"
    static let profileCarColor:String = "carColor"
    static let profileDriverName:String = "driverName"
    static let profileAddress:String = "address"
    static let profileLicenceNumber:String = "licenceNumber"
    static let profileoOwnerAddress:String = "ownerAddress"
    static let profileOwnerPhoneNumber:String = "ownerPhoneNumber"
    static let profileInsuranceCompanyName:String = "insuranceCompanyName"
    static let profileInsurancePolicyNumber:String = "insurancePolicyNumber"
    static let profileInsuranceAgentName:String = "insuranceAgentName"
    static let profileInsuranceAgentPhoneNum:String = "insuranceAgentPhoneNum"
    static let profileProfileImage:String = "profileImage"
    
    static let accidentKey:String = "accidentKey"
    static let accidentUser1:String = "user1"
    static let accidentUser2:String = "user2"
    static let accidentLocationLat:String = "accidentLocationLat"
    static let accidentLocationLong:String = "accidentLocationLong"
    static let accidentDate:String = "accidentDate"
    static let accidentPhotos:String = "photos"
    
    static let accidentImagesDbUploaded: String = "uploadTime"
    static let accidentImagesUrl:String = "url"
}

