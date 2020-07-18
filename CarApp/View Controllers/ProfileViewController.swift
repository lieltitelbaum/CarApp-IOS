//
//  ProfileViewController.swift
//  CarApp
//
//  Created by Liel Titelbaum on 15/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit
import FirebaseAuth
//import Firebase
import FirebaseFirestore
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var saveImageBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var govermentIDTextField: UITextField!
    @IBOutlet weak var carNumberTextField: UITextField!
    @IBOutlet weak var carModelTextField: UITextField!
    @IBOutlet weak var carColorTextField: UITextField!
    @IBOutlet weak var driverNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var ownerAddressTextField: UITextField!
    @IBOutlet weak var licenceNumberTextField: UITextField!
    @IBOutlet weak var insuranceAgentPhoneTextField: UITextField!
    @IBOutlet weak var insuranceAgentNameTextField: UITextField!
    @IBOutlet weak var insurancePolicyNumberTextField: UITextField!
    @IBOutlet weak var insuranceCompanyNameTextField: UITextField!
    @IBOutlet weak var ownerPhoneTextField: UITextField!
    @IBOutlet weak var logOutBtn: UIButton!
    
    private var imageUpload: UIImage? = nil
    private var countPresses = 0
    private var dataBeforeChange = ""
    private let db = Firestore.firestore()
    var userUID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideSaveImageBtn()
        roundedBorderBtn()
        disableTextFields()
        setImage()
        makeProfilePictureRound(image: profileImage)
        retriveUserProfileFromFirebase()
        
    }
    
    func roundedBorderBtn () {
        saveImageBtn.backgroundColor = .clear
        saveImageBtn.layer.cornerRadius = 12
        saveImageBtn.layer.borderWidth = 1
        saveImageBtn.layer.borderColor = UIColor.black.cgColor
    }
    
    func hideSaveImageBtn () {
        saveImageBtn.isEnabled = false
        saveImageBtn.isEnabled = false
        saveImageBtn.alpha = 0
    }
    
    func showSaveImageBtn () {
        saveImageBtn.isEnabled = true
        saveImageBtn.isEnabled = true
        saveImageBtn.alpha = 1
    }
    func disableTextFields() {
        firstNameTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        emailTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        phoneNumberTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        govermentIDTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        carNumberTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        carModelTextField.isEnabled = false
        carColorTextField.isEnabled = false
        driverNameTextField.isEnabled = false
        addressTextField.isEnabled = false
        ownerAddressTextField.isEnabled = false
        licenceNumberTextField.isEnabled = false
        insuranceAgentPhoneTextField.isEnabled = false
        insuranceAgentNameTextField.isEnabled = false
        insurancePolicyNumberTextField.isEnabled = false
        insuranceCompanyNameTextField.isEnabled = false
        ownerPhoneTextField.isEnabled = false
    }
    
    func makeProfilePictureRound(image: UIImageView){
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
    
    func setImage() {
        profileImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        profileImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func presentPicker(){
        showImagePickerControllerChooseSource()
    }
    
    func changeToDoneIcon(btn: UIButton) {
        btn.setImage(#imageLiteral(resourceName: "ok"), for: UIControl.State.normal)
    }
    
    func retriveUserProfileFromFirebase() {
        //check if there is a current user connected and if so, return its uuid
        if Auth.auth().currentUser != nil {
            userUID = Auth.auth().currentUser!.uid
            let firebasePath = db.collection(Constants.FIRE_STORE_DB_PATH).document(userUID)
            firebasePath.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.setTextFieldsTextByFirebaseValues(doc: document)
                    self.loadProfileImage(doc: document)
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func loadProfileImage(doc: DocumentSnapshot) {
        let imageUrl = doc.get(DictKeyConstants.profileProfileImage) as? String
        let url = URL(string: imageUrl!)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: data!)
            }
        }
    }
    func setTextFieldsTextByFirebaseValues(doc: DocumentSnapshot) {
        firstNameTextField.text = doc.get(DictKeyConstants.profileFirstName) as? String
        lastNameTextField.text = doc.get(DictKeyConstants.profileLastName) as? String
        emailTextField.text = doc.get(DictKeyConstants.profileEmail) as? String
        phoneNumberTextField.text = doc.get(DictKeyConstants.profilePhoneNumber) as? String
        govermentIDTextField.text = doc.get(DictKeyConstants.profileUserID) as? String
        carNumberTextField.text = doc.get(DictKeyConstants.profileCarNumber) as? String
        carModelTextField.text = doc.get(DictKeyConstants.profileCarModel) as? String
        carColorTextField.text = doc.get(DictKeyConstants.profileCarColor) as? String
        driverNameTextField.text = doc.get(DictKeyConstants.profileDriverName) as? String
        addressTextField.text = doc.get(DictKeyConstants.profileAddress) as? String
        licenceNumberTextField.text = doc.get(DictKeyConstants.profileLicenceNumber) as? String
        ownerAddressTextField.text = doc.get(DictKeyConstants.profileoOwnerAddress) as? String
        insuranceCompanyNameTextField.text = doc.get(DictKeyConstants.profileInsuranceCompanyName) as? String
        insurancePolicyNumberTextField.text = doc.get(DictKeyConstants.profileInsurancePolicyNumber) as? String
        insuranceAgentNameTextField.text = doc.get(DictKeyConstants.profileInsuranceAgentName) as? String
        insuranceAgentPhoneTextField.text = doc.get(DictKeyConstants.profileInsuranceAgentPhoneNum) as? String
    }
    
    func updateProfileImage() {
        guard let imageSelected = self.imageUpload else {
            print("Image is nil")
            return
        }
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        let storageRef = Storage.storage().reference(forURL: Constants.firebaseStorageRefUrl)
        let storageProfileRef = storageRef.child("profile").child(userUID)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metaData) { (storageMeteData, error) in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            storageProfileRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    FirebaseFunctions.updateValueInProfile(key: DictKeyConstants.profileProfileImage, val: metaImageUrl, userUID: self.userUID)
                }
            }
        }
    }
    
    @IBAction func logOutBtnTapped(_ sender: Any) {
        FirebaseFunctions.logOut()
        let viewController = storyboard?.instantiateViewController(identifier: Constants.loginRegisterViewController) as? ViewController
        
        self.navigationController?.popToRootViewController(animated: true)
        //        self.navigationController?.pushViewController(viewController!, animated: false)
        //        self.navigationController?.isToolbarHidden = false
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
    }
    
    func editFieldData(sender: UIButton, textField: UITextField) -> String {
        //Check if user has changed the text field data-> if so return it.
        //Manage image btn acording to the btn state-> editing/done editing and enabling the textField accordingly
        countPresses += 1
        if(countPresses % 2 == 1){
            //in edit mode
            print("btn is in edit mode")
            dataBeforeChange = textField.text!
            textField.isEnabled = true
            changeToDoneIcon(btn: sender)
        }
        else if(countPresses % 2 == 0){
            sender.setImage(#imageLiteral(resourceName: "Icon-Small"), for: .normal)
            textField.isEnabled = false
            let dataAfterChange = textField.text!
            print("Before: \(dataBeforeChange)")
            print("After: \(dataAfterChange)")
            if dataAfterChange.trimmingCharacters(in: .whitespaces) != dataBeforeChange.trimmingCharacters(in: .whitespaces){
                textField.text = dataAfterChange
                return dataAfterChange
            }
        }
        return "" //if nothing has changed
    }
    
    private func updateProfileValue (txtField: UITextField, sender_btn: UIButton, key: String) {
        //get changed text from editFieldData func
        //if the data has changed-> update field in firebase
        let txtFieldData = editFieldData(sender: sender_btn, textField: txtField).trimmingCharacters(in: .whitespaces)
        print(txtFieldData)
        if txtFieldData != "" {
            print("Starting to update")
            FirebaseFunctions.updateValueInProfile(key: key, val: txtFieldData, userUID: userUID)
        }
    }
    
    //edit fields by tapping on edit icon near each label
    @IBAction func firstNameEditTapped(_ sender: UIButton) {
        updateProfileValue(txtField: firstNameTextField, sender_btn: sender, key: DictKeyConstants.profileFirstName)
    }
    
    @IBAction func lastNameEfitTapped(_ sender: UIButton) {
        updateProfileValue(txtField: lastNameTextField, sender_btn: sender, key: DictKeyConstants.profileLastName)
    }
    
    @IBAction func phoneNumberEditTapped(_ sender: UIButton) {
        updateProfileValue(txtField: phoneNumberTextField, sender_btn: sender, key: DictKeyConstants.profilePhoneNumber)
    }
    
    @IBAction func carNumberEditBtnTapped(_ sender: UIButton) {
        updateProfileValue(txtField: carNumberTextField, sender_btn: sender, key: DictKeyConstants.profileCarNumber)
    }
    
    @IBAction func carModelEditBtnTapped(_ sender: UIButton) {
        updateProfileValue(txtField: carModelTextField, sender_btn: sender, key: DictKeyConstants.profileCarModel)
    }
    
    @IBAction func carColorEditBtnTapped(_ sender: UIButton) {
        updateProfileValue(txtField: carColorTextField, sender_btn: sender, key: DictKeyConstants.profileCarColor)
    }
    
    @IBAction func driverNameEditBtnTapped(_ sender: UIButton) {
        updateProfileValue(txtField: driverNameTextField, sender_btn: sender, key: DictKeyConstants.profileDriverName)
    }
    
    @IBAction func addressEditBtnTapped(_ sender: UIButton) {
        updateProfileValue(txtField: addressTextField, sender_btn: sender, key: DictKeyConstants.profileAddress)
    }
    
    @IBAction func licenceNumberEditBtnTapped(_ sender: UIButton) {
        updateProfileValue(txtField: licenceNumberTextField, sender_btn: sender, key: DictKeyConstants.profileLicenceNumber)
    }
    
    @IBAction func ownerAddressEditBtnTapped(_ sender: UIButton) {
        updateProfileValue(txtField: ownerAddressTextField, sender_btn: sender, key: DictKeyConstants.profileoOwnerAddress)
    }
    
    @IBAction func ownerPhoneNumberEditBtnTapped(_ sender: UIButton) {
        updateProfileValue(txtField: ownerPhoneTextField, sender_btn: sender, key: DictKeyConstants.profileOwnerPhoneNumber)
    }
    
    @IBAction func insuranceCompanyNameEditBtnTapped(_ sender: UIButton) {
        updateProfileValue(txtField: insuranceCompanyNameTextField, sender_btn: sender, key: DictKeyConstants.profileInsuranceCompanyName)
    }
    
    @IBAction func insurancePolicyNumberEditBtnTapped(_ sender: UIButton) {
        updateProfileValue(txtField: insurancePolicyNumberTextField, sender_btn: sender, key: DictKeyConstants.profileInsurancePolicyNumber)
    }
    
    @IBAction func insuranceAgentNameEditBtnTapped(_ sender: UIButton) {
        updateProfileValue(txtField: insuranceAgentNameTextField, sender_btn: sender, key: DictKeyConstants.profileInsuranceAgentName)
    }
    
    @IBAction func insuranceAgentPhoneEditBtnTapped(_ sender: UIButton) {
        updateProfileValue(txtField: insuranceAgentPhoneTextField, sender_btn: sender, key: DictKeyConstants.profileInsuranceAgentPhoneNum)
    }
    
    @IBAction func saveImageTapped(_ sender: Any) {
        updateProfileImage()
        hideSaveImageBtn()
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerChooseSource() {
        //alertController for choosing imagePicker sourceType
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Take from Camera", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            imageUpload = editedImage
            profileImage.image = editedImage
            showSaveImageBtn()
        }
        if let originalImage = info[.originalImage] as? UIImage {
            imageUpload = originalImage
            profileImage.image = originalImage
            showSaveImageBtn()
        }
        dismiss(animated: true, completion: nil)
    }
}
