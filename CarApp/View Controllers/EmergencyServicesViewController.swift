//
//  EmergencyServicesViewController.swift
//  CarApp
//
//  Created by Liel Titelbaum on 12/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit

class EmergencyServicesViewController: UIViewController {
    @IBOutlet weak var callPoliceBtn: UIButton!
    @IBOutlet weak var callMadaBtn: UIButton!
    @IBOutlet weak var callFireBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        UsefulMethods.makeBtnRound(button: callFireBtn)
        UsefulMethods.makeBtnRound(button: callMadaBtn)
        UsefulMethods.makeBtnRound(button: callPoliceBtn)
    }
    
    func callNumber(number: String){
        guard let number = URL(string: "tel://" + number) else { return }
        UIApplication.shared.open(number)
    }
    
    @IBAction func callPoliceTapped(_ sender: Any) {
        callNumber(number: "100")
    }
    
    @IBAction func callMadaTapped(_ sender: Any) {
        callNumber(number: "101")
    }
    
    @IBAction func callFireTapped(_ sender: Any) {
        callNumber(number: "102")
    }
    
}
