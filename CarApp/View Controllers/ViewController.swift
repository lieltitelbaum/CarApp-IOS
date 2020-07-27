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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UsefulMethods.makeBtnRound(button: logInBtn)
        UsefulMethods.makeBtnRound(button: signUpBtn)
    }
}

