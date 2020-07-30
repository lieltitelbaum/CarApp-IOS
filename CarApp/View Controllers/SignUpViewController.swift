//
//  SignUpViewController.swift
//  CarApp
//
//  Created by Liel Titelbaum on 08/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var phoneNumberTxt: UITextField!
    @IBOutlet weak var userIdNumberTxt: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var firstNameErrorLbl: UILabel!
    @IBOutlet weak var lastNameErrorLbl: UILabel!
    @IBOutlet weak var emailErrorLbl: UILabel!
    @IBOutlet weak var passwordErrorLbl: UILabel!
    @IBOutlet weak var userIdErrorLbl: UITextField!
    @IBOutlet weak var phoneNumberErrorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideLabels()
        delgateAllTextFields()
        
        UsefulMethods.makeBtnRound(button: signUpBtn)
        UsefulMethods.makeRedBorderToBtn(button: signUpBtn)
    }
    
    func hideLabels() {
        passwordErrorLbl.alpha = 0
        phoneNumberErrorLbl.alpha = 0
        errorLbl.alpha = 0
        emailErrorLbl.alpha = 0
        userIdErrorLbl.alpha = 0
        lastNameErrorLbl.alpha = 0
        firstNameErrorLbl.alpha = 0
    }
    
    func delgateAllTextFields() {
        firstNameTxt.delegate = self
        lastNameTxt.delegate = self
        emailTxt.delegate = self
        passwordTxt.delegate = self
        phoneNumberTxt.delegate = self
        userIdNumberTxt.delegate = self
    }
    
    func isAllFieldsValid() -> Bool {
        var flag:Bool = true
        
        hideLabels()
        
        if !ValidateFields.isPhoneNumberValid((phoneNumberTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines))!) {
            phoneNumberErrorLbl.alpha = 1
            phoneNumberErrorLbl.text = "Phone number is not in the correct format, need to be 10 digits."
            flag = false
        }
        
        if !ValidateFields.isValidEmail((emailTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines))!) {
            emailErrorLbl.alpha = 1
            emailErrorLbl.text = "Email is not in the correct format."
            flag = false
        }
        
        if !ValidateFields.isGovernmentIdValid((userIdNumberTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines))!) {
            userIdErrorLbl.alpha = 1
            userIdErrorLbl.text = "ID number is not in the correct format, need to be 9 digits."
            flag = false
        }
        
        let cleanPass = passwordTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !ValidateFields.isPasswordValid(cleanPass) {
            //password is not secure enough
            passwordErrorLbl.alpha = 1
            passwordErrorLbl.text = "Please make sure your password is at least 8 characters, contains a special character and a number."
            flag = false
        }
        
        if !ValidateFields.isFieldIsNonNumeric((firstNameTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines))!) {
            firstNameErrorLbl.alpha = 1
            firstNameErrorLbl.text = "First name must contain only letters."
            flag = false
        }
        
        if !ValidateFields.isFieldIsNonNumeric((lastNameTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines))!) {
            lastNameErrorLbl.alpha = 1
            lastNameErrorLbl.text = "Last name must contain only letters."
            flag = false
        }
        return flag
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        //validate the fields
        let isValid = isAllFieldsValid()
        
        if isValid{
            //create the user
            let firstName = firstNameTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phone = phoneNumberTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let userID = userIdNumberTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //Check for errors
                if err != nil {
                    //There was an error creating the user
                    print(err!.localizedDescription)
                    self.showError(message:err!.localizedDescription)
                }
                else {
                    //User was created successfully, now store other fields in database
                    let db = Firestore.firestore()
                    let profile = Profile(key: result!.user.uid, firstName: firstName, lastName: lastName, email: email, phoneNumber: phone, userID: userID)
                    //add new user to firebase db with key as uid
                    db.collection(Constants.fireStoreDbUsers).document(result!.user.uid).setData(profile.convertToDict()) { (error) in
                        
                        if error != nil {
                            //print error
                            print("Error saving user to firestore with first name: \(firstName) and last name \(lastName)")
                        }
                    }
                    self.performSegue(withIdentifier: Constants.fromSignUpToHomeVc, sender: self)
                }
            }
        }
    }
    
    //UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //When pressed on the return button in the keyboard, the keyboard is dismmised
        textField.resignFirstResponder()
        return true
    }
    
    func showError(message: String) {
        errorLbl.text = message
        errorLbl.alpha = 1
    }
}
