//
//  ImageViewController.swift
//  CarApp
//
//  Created by Liel Titelbaum on 24/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    var imageUpload: UIImage? = nil
    var accidentKey: String!
    var didUserAddImage: Bool! //if the user wants to add image or to show image in fuller screen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        setUpSaveBtn()
        print("Image vc: \n imageview \(String(describing: imageUpload ?? nil))")
        print("accident key: \(accidentKey ?? "")")
    }
    private func setupImageView() {
        DispatchQueue.main.async {
            self.imageView.image = self.imageUpload
        }
    }
    
    private func setUpSaveBtn() {
        if(!didUserAddImage) {
            saveBtn.alpha = 0
            saveBtn.isEnabled = false
        }
        else {
            saveBtn.alpha = 1
            saveBtn.isEnabled = true
        }
    }
    
    @IBAction func saveImagePressed(_ sender: Any) {
        //if user pressed add image in the previous screen -> add the new image to firebase storage and after that add it to firestore by compatible accident id
//        if(didUserAddImage) {
            guard let imageSelected = self.imageUpload else {
                print("Image is nil")
                return
            }
            
            guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
                print("image data is empty")
                return
            }
            //add image to firestorage and get its' url
        
        FirebaseFunctions.uploadImageToFirestorage(childNameInStoragePath: Constants.accidentImagesFireStorageRef, imageName: UUID().uuidString, imageData: imageData) { (urlString) in
            print("\nimageUrl\(urlString)")
            //upload image to firestore
            FirebaseFunctions.addImageToAccidentsFirestore(imagesAccidentKey: self.accidentKey, imageUrl: urlString)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
