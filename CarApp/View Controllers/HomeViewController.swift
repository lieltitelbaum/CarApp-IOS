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
        
        let userUID = getCurrentuser()
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
        let firebasePath = db.collection(Constants.FIRE_STORE_DB_PATH).document(userUID)
        firebasePath.getDocument { (document, error) in
            if let document = document, document.exists {
                let firstName = document.get("firstName")
                let lastName = document.get("lastName")
                self.welcomeLabel.text = "Welcome \(firstName!) \(lastName!)"
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
    func getCurrentuser() -> String {
        //check if there is a current user connected and if so, return its uuid
        if Auth.auth().currentUser != nil {
            return Auth.auth().currentUser!.uid
        }
        return "" //if there is no current user connected
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
