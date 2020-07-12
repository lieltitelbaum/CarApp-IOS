//
//  ValidateFields.swift
//  CarApp
//
//  Created by Liel Titelbaum on 09/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import Foundation
import UIKit

class ValidateFields {
    
    //password validation
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$!%*?$])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

    static func isValidEmail(_ email: String) -> Bool {
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailPred.evaluate(with: email)
        
    }
    
     //check the fields and validate that the data is correct. If so, this method return nil. Oterwise,it returns the error msg
    static func validateFields(_ field: UITextField) -> String? {
           //Check that all fields are fileed in
           if field.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
               return "Please fill in all fields."
           }
           return nil
       }
    
//    static func isPhoneNumberValid(_ phone: String) -> Bool {
//
//    }
//
//    static func isGovermentIdValid(_ id: String) -> Bool {
//
//    }
    
}
