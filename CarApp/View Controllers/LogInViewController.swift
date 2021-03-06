//
//  LogInViewController.swift
//  CarApp
//
//  Created by Liel Titelbaum on 08/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTxt.delegate = self
        passwordTxt.delegate = self
        
        UsefulMethods.makeBtnRound(button: logInBtn)
        UsefulMethods.makeRedBorderToBtn(button: logInBtn)
        errorLbl.alpha = 0//label is not shown
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        //Validate text fields to do
        //check errors
        let email = emailTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        signIn(email: email, password: password)
    }
    
    //UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //When pressed on the return button in the keyboard, the keyboard is dismmised
        textField.resignFirstResponder()
        return true
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorLbl.text = error!.localizedDescription
                self.errorLbl.alpha = 1 //showing the error
            }
            else {
                self.performSegue(withIdentifier: Constants.fromLogToHomeVc, sender: self)
            }
        }
    }
}
