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

    }
    
    @IBAction func callPoliceTapped(_ sender: Any) {
        guard let number = URL(string: "tel://" + "100") else { return }
           UIApplication.shared.open(number)
    }
    @IBAction func callMadaTapped(_ sender: Any) {
        guard let number = URL(string: "tel://" + "101") else { return }
           UIApplication.shared.open(number)
    }
    @IBAction func callFireTapped(_ sender: Any) {
        guard let number = URL(string: "tel://" + "102") else { return }
           UIApplication.shared.open(number)
    }
}
