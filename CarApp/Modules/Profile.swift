//
//  Profile.swift
//  CarApp
//
//  Created by Liel Titelbaum on 11/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Profile {
    var key: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var emailAddress: String = ""
    var phoneNumber: String = ""
    var userID: String = ""
    
    var carNumber: String = ""
    var carModel: String = ""
    var carColor: String = ""
    var driverName: String = ""
    var address: String = ""
    var licenceNumber: String = ""
    var ownerAddress: String = ""
    var ownerPhoneNumber: String = ""
    var insuranceCompanyName: String = ""
    var insurancePolicyNumber: String = ""
    var insuranceAgentName: String = ""
    var insuranceAgentPhoneNum: String = ""
    var profileImage: String = ""
    
    var dict: [String:Any] = [:]

    init() {
        
    }
    
    init(key: String, firstName:String, lastName:String, email:String, phoneNumber: String, userID: String){
        self.key = key
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = email
        self.phoneNumber = phoneNumber
        self.userID = userID
    }
    
    func convertToDict() -> Dictionary<String, Any>{
        //TODO: convert string key to enum or constants
        dict = ["keyId": self.key, "firstName":self.firstName, "lastName": self.lastName, "email": self.emailAddress, "phoneNumber": self.phoneNumber, "userID": self.userID, "carNumber": self.carNumber, "carModel": self.carModel, "carColor": self.carColor, "driverName": self.driverName, "address": self.address, "licenceNumber": self.licenceNumber, "ownerAddress": self.ownerAddress, "ownerPhoneNumber": self.ownerPhoneNumber, "insuranceCompanyName": self.insuranceCompanyName, "insurancePolicyNumber": self.insurancePolicyNumber, "insuranceAgentName": self.insuranceAgentName, "insuranceAgentPhoneNum": self.insuranceAgentPhoneNum, "profileImage":self.profileImage]
        return dict
    }
    
    func getUserKeyId()->String{
        return self.key
    }
    
    func getUserFirstName() ->String {
        return self.firstName
    }
    
    func getUserLastName() -> String {
        return self.lastName
    }
    
    //updates functions
    func updateProfilePhoto(_ photoUrl: String) {
        self.profileImage = photoUrl
        self.dict["profileImage"] = photoUrl
    }

    func updateFirstName(_ firstName: String) {
          self.firstName = firstName
          self.dict["firstName"] = firstName
      }

    func updatLastName(_ lastName: String) {
          self.lastName = lastName
          self.dict["lastName"] = lastName
      }

    func updatePhoneNumber(_ phoneNumber: String) {
          self.phoneNumber = phoneNumber
          self.dict["phoneNumber"] = phoneNumber
      }

    func updateCarNumber(_ carNumber: String) {
        self.carNumber = carNumber
        self.dict["carNumber"] = carNumber
    }

    func updateCarModel(_ carModel: String) {
        self.carModel = carModel
        self.dict["carModel"] = carModel
    }

    func updateCarColor(_ carColor: String) {
        self.carColor = carColor
        self.dict["carColor"] = carColor
    }

    func updateDriverName(_ driverName: String) {
        self.driverName = driverName
        self.dict["driverName"] = driverName
    }

    func updateAddress(_ address: String) {
        self.address = address
        self.dict["address"] = address
    }
    func updateLicenceNumber(_ licenceNumber: String) {
        self.licenceNumber = licenceNumber
        self.dict["licenceNumber"] = licenceNumber
    }

    func updateOwnerAddress(_ ownerAddress: String) {
        self.ownerAddress = ownerAddress
        self.dict["ownerAddress"] = ownerAddress
    }

    func updateOwnerPhoneNumber(_ ownerPhoneNumber: String) {
        self.ownerPhoneNumber = ownerPhoneNumber
        self.dict["ownerPhoneNumber"] = ownerPhoneNumber
    }

    func updateInsuranceCompanyName(_ insuranceCompanyName: String) {
        self.insuranceCompanyName = insuranceCompanyName
        self.dict["insuranceCompanyName"] = insuranceCompanyName
    }

    func updateInsurancePolicyNumber(_ insurancePolicyNumber: String) {
        self.insurancePolicyNumber = insurancePolicyNumber
        self.dict["insurancePolicyNumber"] = insurancePolicyNumber
    }

    func updateIinsuranceAgentName(_ insuranceAgentName: String) {
        self.insuranceAgentName = insuranceAgentName
        self.dict["insuranceAgentName"] = insuranceAgentName
    }

}
