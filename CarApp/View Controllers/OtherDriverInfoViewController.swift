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
//        UsefulMethods.makemakeProfilePictureRound(profileImage)
    }
    
    private func setFields () {
       let userDict = FirebaseFunctions.getUserInfo(userUID: userUID)
        
        let firstName = userDict[DictKeyConstants.profileFirstName] as! String
        let lastName = userDict[DictKeyConstants.profileLastName] as! String
        
        fullNameLabel.text = "\(firstName) \(lastName)"
        emailTextField.text = userDict[DictKeyConstants.profileEmail] as? String
        phoneNumberTextField.text = userDict[DictKeyConstants.profilePhoneNumber] as? String
        licenceNumberTextField.text = userDict[DictKeyConstants.profileLicenceNumber] as? String
        ownerPhoneNumberTextField.text = userDict[DictKeyConstants.profileOwnerPhoneNumber] as? String
        insurancePolicyNumberTextFeild.text = userDict[DictKeyConstants.profileInsurancePolicyNumber] as? String
        insuranceCompanyNameTextField.text = userDict[DictKeyConstants.profileInsuranceCompanyName] as? String
        addressTextField.text = userDict[DictKeyConstants.profileAddress] as? String
        driverNameTextField.text = userDict[DictKeyConstants.profileDriverName] as? String
        carColorTextField.text = userDict[DictKeyConstants.profileCarColor] as? String
        carModelTextField.text = userDict[DictKeyConstants.profileCarModel] as? String
        carNumberTextField.text = userDict[DictKeyConstants.profileCarNumber] as? String
        govIDNumTextField.text = userDict[DictKeyConstants.profileUserID] as? String
        insuranceAgentNameTextField.text = userDict[DictKeyConstants.profileInsuranceAgentName] as? String
        insuranceAgentPhoneNumberTextField.text = userDict[DictKeyConstants.profileInsuranceAgentPhoneNum] as? String
        ownerAddressTextField.text = userDict[DictKeyConstants.profileoOwnerAddress] as? String
        //present profile image
        let imageUrl = userDict[DictKeyConstants.profileProfileImage] as! String
//        UsefulMethods.showProfileImageFromUrl(imageUrl: imageUrl, profileImage: profileImage)
        
        
    }
}
