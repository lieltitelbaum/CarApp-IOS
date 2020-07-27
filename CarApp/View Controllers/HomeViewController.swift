//
//  HomeViewController.swift
//  CarApp
//
//  Created by Liel Titelbaum on 08/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var emergencyBtn: UIButton!
    @IBOutlet weak var scanBarcodeBtn: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
    private let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UsefulMethods.makeBtnRound(button: emergencyBtn)
        UsefulMethods.makeBtnRound(button: scanBarcodeBtn)
        
        let userUID = FirebaseFunctions.getCurrentUserUId()
        if userUID != "" {
            getUserNameAndPresentIt(userUID: userUID)
            qrCodeImage.image = generateQRCode(from: userUID)
        }
        else {
            //user is not logged in, returns to app first screen
            transitionToLogInRegisterScreen()
        }
        
    }
    
    func getUserNameAndPresentIt(userUID: String) {
        //retrive user first and last name and show it in the welcome label
        
        var firstName: String = ""
        var lastName: String = ""
        FirebaseFunctions.getUserInfo(userUID: userUID, callBack: { (userDict) in
            guard let userDict = userDict else {
                print("current logged user dict is empty")
                return
            }
            firstName = userDict[DictKeyConstants.profileFirstName] as! String
            lastName = userDict[DictKeyConstants.profileLastName] as! String
            print("---")
            self.welcomeLabel.text = "Welcome \(firstName) \(lastName)"
        })
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        //generate QRcode by user UUID (user key id)
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
        //        let scanViewController = self.storyboard?.instantiateViewController(identifier: Constants.scanViewController) as? ScannerViewController
        //
        //                       self.navigationController?.pushViewController(scanViewController!, animated: false)
        //                       self.dismiss(animated: false, completion: nil)
        ////        performSegue(withIdentifier: "scanCode", sender: self)
    }
    
    
    func transitionToLogInRegisterScreen() {
        let viewController = storyboard?.instantiateViewController(identifier: Constants.loginRegisterViewController) as? ViewController
        
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
    }
}
