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

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var phoneNumberTxt: UITextField!
    @IBOutlet weak var userIdNumberTxt: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func validateFields() -> String? {
        //Check that all fields are fileed in
        if firstNameTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        let cleanPass = passwordTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if ValidateFields.isPasswordValid(cleanPass) == false {
            //password is not secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        if ValidateFields.isValidEmail((emailTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines))!) == false {
            return "Email is not in the correct format"
        }
        return nil
    }
    @IBAction func signUpPressed(_ sender: Any) {
        //validate the fields
        let error = validateFields()
        
        if error != nil{
            //There's something wrong with the fields -> show error msg
            showError(message: error!)
        }
        else {
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
                    self.showError(message: "Error creating user")
                }
                else {
                    //User was created successfully, now store other fields in database
                    let db = Firestore.firestore()
                    let profile = Profile(key: result!.user.uid, firstName: firstName, lastName: lastName, email: email, phoneNumber: phone, userID: userID)
                    //add new user to firebase db with key as uid
                    db.collection(Constants.FIRE_STORE_DB_PATH).document(result!.user.uid).setData(profile.convertToDict()) { (error) in
                        
                        if error != nil {
                            //print error
                            print("Error saving user to firestore with first name: \(firstName) and last name \(lastName)")
                        }
                    }
                    self.transitionToHomeScreen()
                }
            }
        }
    }
    
    func transitionToHomeScreen() {
        let tabBarViewController = self.storyboard?.instantiateViewController(identifier: "tabbarvc") as? UITabBarController
        
        self.dismiss(animated: false, completion: nil)
        self.view.window?.rootViewController = tabBarViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    func showError(message: String) {
        errorLbl.text = message
        errorLbl.alpha = 1
    }
}
