//
//  LogInViewController.swift
//  CarApp
//
//  Created by Liel Titelbaum on 08/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        //Validate text fields to do
        //check errors
        let email = emailTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        signIn(email: email, password: password)
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorLbl.text = error!.localizedDescription
                self.errorLbl.alpha = 1 //showing the error
            }
            else {
                let tabBarViewController = self.storyboard?.instantiateViewController(identifier: "tabbarvc") as? UITabBarController//TODO:: const

                self.dismiss(animated: false, completion: nil)
                self.view.window?.rootViewController = tabBarViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
