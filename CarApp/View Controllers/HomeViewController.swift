//
//  HomeViewController.swift
//  CarApp
//
//  Created by Liel Titelbaum on 08/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var emergencyBtn: UIButton!
    @IBOutlet weak var scanBarcodeBtn: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userUID = getCurrentuser()
        if userUID != "" {
            qrCodeImage.image = generateQRCode(from: userUID)
        }
        else {
            //user is not logged in, returns to app first screen
            transitionToLogInRegisterScreen()
        }
        
    }
    
    func getCurrentuser() -> String {
        if Auth.auth().currentUser != nil {
            return Auth.auth().currentUser!.uid
        }
        return "" //if there is not current user connected
    }
    
   func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

    
    @IBAction func scanbarcodeClicked(_ sender: Any) {
    }
    
    @IBAction func emergencyClicked(_ sender: Any) {
        
    }
    
    func transitionToLogInRegisterScreen() {
         let viewController = storyboard?.instantiateViewController(identifier: Constants.loginRegisterViewController) as? ViewController
         
         view.window?.rootViewController = viewController
         view.window?.makeKeyAndVisible()
     }
}
