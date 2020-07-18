//
//  AccidentInfoViewController.swift
//  CarApp
//
//  Created by Liel Titelbaum on 18/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit

class AccidentInfoViewController: UIViewController {
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var otherDriverDetailsBtn: UIButton!
    @IBOutlet weak var imagesCollection: UICollectionView!
    
    var accidentKey: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  

}
