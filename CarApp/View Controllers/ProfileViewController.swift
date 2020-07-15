//
//  ProfileViewController.swift
//  CarApp
//
//  Created by Liel Titelbaum on 15/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var govermentIDTextField: UITextField!
    @IBOutlet weak var carNumberTextField: UITextField!
    @IBOutlet weak var carModelTextField: UITextField!
    @IBOutlet weak var carColorTextField: UITextField!
    @IBOutlet weak var driverNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var ownerAddressTextField: UITextField!
    @IBOutlet weak var licenceNumberTextField: UITextField!
    @IBOutlet weak var insuranceAgentPhoneTextField: UITextField!
    @IBOutlet weak var insuranceAgentNameTextField: UITextField!
    @IBOutlet weak var insurancePolicyNumberTextField: UITextField!
    @IBOutlet weak var insuranceCompanyNameTextField: UITextField!
    @IBOutlet weak var ownerPhoneTextField: UITextField!
    @IBOutlet weak var logOutBtn: UIButton!
    
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableTextFields()
        makeProfilePictureRound(image: profileImage)
        retriveUserProfileFromFirebase()
        
    }
    
    func disableTextFields() {
        firstNameTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        emailTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        phoneNumberTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        govermentIDTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        carNumberTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        carModelTextField.isEnabled = false
        carColorTextField.isEnabled = false
        driverNameTextField.isEnabled = false
        addressTextField.isEnabled = false
        ownerAddressTextField.isEnabled = false
        licenceNumberTextField.isEnabled = false
        insuranceAgentPhoneTextField.isEnabled = false
        insuranceAgentNameTextField.isEnabled = false
        insurancePolicyNumberTextField.isEnabled = false
        insuranceCompanyNameTextField.isEnabled = false
        ownerPhoneTextField.isEnabled = false
    }
    
    func makeProfilePictureRound(image: UIImageView){
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.cornerRadius = image.frame.height/2
        print(image.frame.height/2)
        image.clipsToBounds = true
    }
    
    func changeToDoneIcon(btn: UIButton) {
        btn.setImage(#imageLiteral(resourceName: "done"), for: UIControl.State.normal)
    }
    
    func retriveUserProfileFromFirebase() {
        //check if there is a current user connected and if so, return its uuid
        if Auth.auth().currentUser != nil {
            let userUID = Auth.auth().currentUser!.uid
            let firebasePath = db.collection(Constants.FIRE_STORE_DB_PATH).document(userUID)
            firebasePath.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.setTextFieldsTextByFirebaseValues(doc: document)
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        //retrive user first and last name and show it in the welcome label
    }
    
    func setTextFieldsTextByFirebaseValues(doc: DocumentSnapshot) {
        firstNameTextField.text = doc.get(DictKeyConstants.profileFirstName) as? String
        lastNameTextField.text = doc.get(DictKeyConstants.profileLastName) as? String
        emailTextField.text = doc.get(DictKeyConstants.profileEmail) as? String
        phoneNumberTextField.text = doc.get(DictKeyConstants.profilePhoneNumber) as? String
        govermentIDTextField.text = doc.get(DictKeyConstants.profileUserID) as? String
        carNumberTextField.text = doc.get(DictKeyConstants.profileCarNumber) as? String
        carModelTextField.text = doc.get(DictKeyConstants.profileCarModel) as? String
        carColorTextField.text = doc.get(DictKeyConstants.profileCarColor) as? String
        driverNameTextField.text = doc.get(DictKeyConstants.profileDriverName) as? String
        addressTextField.text = doc.get(DictKeyConstants.profileAddress) as? String
        licenceNumberTextField.text = doc.get(DictKeyConstants.profileLicenceNumber) as? String
        ownerAddressTextField.text = doc.get(DictKeyConstants.profileoOwnerAddress) as? String
        insuranceCompanyNameTextField.text = doc.get(DictKeyConstants.profileInsuranceCompanyName) as? String
        insurancePolicyNumberTextField.text = doc.get(DictKeyConstants.profileInsurancePolicyNumber) as? String
        insuranceAgentNameTextField.text = doc.get(DictKeyConstants.profileInsuranceAgentName) as? String
        insuranceAgentPhoneTextField.text = doc.get(DictKeyConstants.profileInsuranceAgentPhoneNum) as? String
    }
    
    func setProfileImage() {
        //TODO
    }
    
    func updateProfileImage() {
        //TODO
    }
    
    @IBAction func logOutBtnTapped(_ sender: Any) {
        FirebaseFunctions.logOut()
        let viewController = storyboard?.instantiateViewController(identifier: Constants.loginRegisterViewController) as? ViewController
        
        self.navigationController?.pushViewController(viewController!, animated: false)
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
    }
    
    func editFieldData(sender: UIButton, textField: UITextField) -> String {
        //Check if user has changed the text field data-> if so return it.
        //Manage image btn acording to the btn state-> editing/done editing and enabling the textField accordingly
        let dataBeforeChange = textField.text!
        if(sender.currentImage == #imageLiteral(resourceName: "Icon-Small")) {
            print("btn is in edir mode")
            sender.isEnabled = true
            changeToDoneIcon(btn: sender)
        }
        if(sender.currentImage == #imageLiteral(resourceName: "done")) {
            let dataAfterChange = textField.text!
            if dataAfterChange.trimmingCharacters(in: .whitespaces) != dataBeforeChange.trimmingCharacters(in: .whitespaces){
                textField.text = dataAfterChange
                sender.setImage(#imageLiteral(resourceName: "Icon-Small"), for: UIControl.State.normal)
                textField.isEnabled = false
                return dataAfterChange
            }
        }
        return "" //if nothing has changed
    }
    
    func updateValueInFirebase (key: String, value: Any) {
        
    }
    
    //edit fields by tapping on edit icon near each label
    @IBAction func firstNameEditTapped(_ sender: UIButton) {
        if editFieldData(sender: sender, textField: firstNameTextField) != "" {
            //update in firebase
        }
        
    }
    
    @IBAction func lastNameEfitTapped(_ sender: UIButton) {
        if editFieldData(sender: sender, textField: lastNameTextField) != "" {
                  //update in firebase
              }
    }
    
    @IBAction func phoneNumberEditTapped(_ sender: UIButton) {
        if editFieldData(sender: sender, textField: phoneNumberTextField) != "" {
                  //update in firebase
              }
    }
    
    @IBAction func carNumberEditBtnTapped(_ sender: UIButton) {
        if editFieldData(sender: sender, textField: carNumberTextField) != "" {
                  //update in firebase
              }
    }
    
    @IBAction func carModelEditBtnTapped(_ sender: UIButton) {
        if editFieldData(sender: sender, textField: carModelTextField) != "" {
                  //update in firebase
              }
    }
    
    @IBAction func carColorEditBtnTapped(_ sender: UIButton) {
        if editFieldData(sender: sender, textField: carColorTextField) != "" {
                  //update in firebase
              }
    }
    
    @IBAction func driverNameEditBtnTapped(_ sender: UIButton) {
        if editFieldData(sender: sender, textField: driverNameTextField) != "" {
                  //update in firebase
              }
    }
    
    @IBAction func addressEditBtnTapped(_ sender: UIButton) {
        if editFieldData(sender: sender, textField: addressTextField) != "" {
                  //update in firebase
              }
    }
    
    @IBAction func licenceNumberEditBtnTapped(_ sender: UIButton) {
        if editFieldData(sender: sender, textField: licenceNumberTextField) != "" {
                  //update in firebase
              }
    }
    
    @IBAction func ownerAddressEditBtnTapped(_ sender: UIButton) {
        if editFieldData(sender: sender, textField: ownerAddressTextField) != "" {
                  //update in firebase
              }
    }
    
    @IBAction func ownerPhoneNumberEditBtnTapped(_ sender: UIButton) {
        if editFieldData(sender: sender, textField: ownerPhoneTextField) != "" {
                  //update in firebase
              }
    }
    
    @IBAction func insuranceCompanyNameEditBtnTapped(_ sender: UIButton) {
        if editFieldData(sender: sender, textField: insuranceCompanyNameTextField) != "" {
                  //update in firebase
              }
    }
    
    @IBAction func insurancePolicyNumberEditBtnTapped(_ sender: UIButton) {
        if editFieldData(sender: sender, textField: insurancePolicyNumberTextField) != "" {
                  //update in firebase
              }
    }
    
    @IBAction func insuranceAgentNameEditBtnTapped(_ sender: UIButton) {
        if editFieldData(sender: sender, textField: insuranceAgentNameTextField) != "" {
                  //update in firebase
              }
    }
    
    @IBAction func insuranceAgentPhoneEditBtnTapped(_ sender: UIButton) {
        if editFieldData(sender: sender, textField: insuranceAgentPhoneTextField) != "" {
                  //update in firebase
              }
    }
}
