//
//  ViewController.swift
//  CarApp
//
//  Created by Liel Titelbaum on 08/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        buttonsAreVisible()
        moveToHomeVc()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        buttonsAreVisible()
        
        UsefulMethods.makeBtnRound(button: logInBtn)
        UsefulMethods.makeBtnRound(button: signUpBtn)
        UsefulMethods.makeRedBorderToBtn(button: logInBtn)
        UsefulMethods.makeRedBorderToBtn(button: signUpBtn)
        
        //        moveToHomeVc()
    }
    private func moveToHomeVc () {
        if(FirebaseFunctions.isUserLoggedIn()) {
            print(FirebaseFunctions.getCurrentUserUId())
            //go to home vc with logged user
            logInBtn.alpha = 0
            signUpBtn.alpha = 0
            
            //after 1.5 seconds move to home vc (tab bar controller)
            DispatchQueue.main.asyncAfter(deadline:.now() + 1.5, execute: {
                self.performSegue(withIdentifier: Constants.homeVcWithLoggedUser, sender: self)
            })
        }
        else {
            buttonsAreVisible()
        }
    }
    
    private func buttonsAreVisible() {
        logInBtn.alpha = 1
        signUpBtn.alpha = 1
    }
}

