//
//  OtherDriverInfoViewController.swift
//  CarApp
//
//  Created by Liel Titelbaum on 18/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit

class OtherDriverInfoViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var licenceNumberTextField: UITextField!
    @IBOutlet weak var ownerPhoneNumberTextField: UITextField!
    @IBOutlet weak var insurancePolicyNumberTextFeild: UITextField!
    @IBOutlet weak var insuranceCompanyNameTextField: UITextField!
    @IBOutlet weak var ownerAddressTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var driverNameTextField: UITextField!
    @IBOutlet weak var carColorTextField: UITextField!
    @IBOutlet weak var carModelTextField: UITextField!
    @IBOutlet weak var carNumberTextField: UITextField!
    @IBOutlet weak var govIDNumTextField: UITextField!
    @IBOutlet weak var insuranceAgentNameTextField: UITextField!
    @IBOutlet weak var insuranceAgentPhoneNumberTextField: UITextField!
    
    var userUID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFields()
        UsefulMethods.makePictureRound(image: profileImage)
    }
    
    private func setFields () {
        //get other driver profile information
        FirebaseFunctions.getUserInfo(userUID: userUID) { (dict) in
            guard let userDict = dict else {
                print("Other driver info is empty")
                return
            }
            print("\n other driver info \(userDict)")
            
            let firstName = userDict[DictKeyConstants.profileFirstName] as! String
            let lastName = userDict[DictKeyConstants.profileLastName] as! String
            
            //set fields with data
            self.fullNameLabel.text = "\(firstName) \(lastName)"
            self.emailTextField.text = userDict[DictKeyConstants.profileEmail] as? String
            self.phoneNumberTextField.text = userDict[DictKeyConstants.profilePhoneNumber] as? String
            self.licenceNumberTextField.text = userDict[DictKeyConstants.profileLicenceNumber] as? String
            self.ownerPhoneNumberTextField.text = userDict[DictKeyConstants.profileOwnerPhoneNumber] as? String
            self.insurancePolicyNumberTextFeild.text = userDict[DictKeyConstants.profileInsurancePolicyNumber] as? String
            self.insuranceCompanyNameTextField.text = userDict[DictKeyConstants.profileInsuranceCompanyName] as? String
            self.addressTextField.text = userDict[DictKeyConstants.profileAddress] as? String
            self.driverNameTextField.text = userDict[DictKeyConstants.profileDriverName] as? String
            self.carColorTextField.text = userDict[DictKeyConstants.profileCarColor] as? String
            self.carModelTextField.text = userDict[DictKeyConstants.profileCarModel] as? String
            self.carNumberTextField.text = userDict[DictKeyConstants.profileCarNumber] as? String
            self.govIDNumTextField.text = userDict[DictKeyConstants.profileUserID] as? String
            self.insuranceAgentNameTextField.text = userDict[DictKeyConstants.profileInsuranceAgentName] as? String
            self.insuranceAgentPhoneNumberTextField.text = userDict[DictKeyConstants.profileInsuranceAgentPhoneNum] as? String
            self.ownerAddressTextField.text = userDict[DictKeyConstants.profileoOwnerAddress] as? String
            //present profile image
            let imageUrl = userDict[DictKeyConstants.profileProfileImage] as? String ?? ""
            print("other driver image Url: \(imageUrl)")
            UsefulMethods.showProfileImageFromUrl(imageUrl: imageUrl, profileImage: self.profileImage)
            
        }
    }
}
