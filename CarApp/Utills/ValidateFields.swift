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
    
    static func isPhoneNumberValid(_ phone: String) -> Bool {
        let phoneRegex = "^[0][5][0|2|3|4|5|9]{1}[-]{0,1}[0-9]{7}$"
               let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
               return phoneTest.evaluate(with: phone)
    }

    static func isGovernmentIdValid(_ id: String) -> Bool {
        let idRegax = "([0-9]){9}$"
        let idTest = NSPredicate(format: "SELF MATCHES %@", idRegax)
        return idTest.evaluate(with: id)
    }
    
    static func isFieldIsNonNumeric(_ txt: String) -> Bool {
        let lettersRegax = "^[A-Za-z]+$"
        let lettersTest = NSPredicate(format: "SELF MATCHES %@", lettersRegax)
        return lettersTest.evaluate(with: txt)
    }

}
