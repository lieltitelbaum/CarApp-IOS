//
//  AccidentInfoViewController.swift
//  CarApp
//
//  Created by Liel Titelbaum on 18/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts
import Photos
import AVFoundation

class AccidentInfoViewController: UIViewController {
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var otherDriverDetailsBtn: UIButton!
    @IBOutlet weak var imagesCollection: UICollectionView!
    
    @IBOutlet weak var addImageBtn: UIButton!
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    private var imageUpload: UIImage? = nil
    var accidentKey: String = ""
    private var accidentUser2Key: String = ""
    var isUserAddingImage: Bool = false
    var imagesUrlList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesCollection.allowsMultipleSelection = false
        
        loadAccidentDetails()
        setUpCollectionView()
        setUpCollectionViewItemSize() 
    }
    
    private func setUpCollectionView() {
        imagesCollection.delegate = self
        imagesCollection.dataSource = self
    }
    
    private func setUpCollectionViewItemSize() {
        if(collectionViewFlowLayout == nil) {
            let numberOfItemsPerRow: CGFloat = 3
            let lineSpacing:CGFloat = 5
            let interItemSpacing:CGFloat = 5
            
            let width = (imagesCollection.frame.width - (numberOfItemsPerRow - 1) * interItemSpacing) / numberOfItemsPerRow
            let height = width
            
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            
            collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.minimumLineSpacing = lineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
            
            imagesCollection.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
    }
    
    private func loadAccidentDetails() {
        let loadedAccidentDict = FirebaseFunctions.getAccidentsFromFirebase(accidentKey: accidentKey)
        let accident = Accident.convertDictToAccidentObj(dict: loadedAccidentDict)
        dateLbl.text = accident.accidentDate
        //        let address = CLGeocoder.init()
        let currentUserKey:String = FirebaseFunctions.getCurrentUserUId()
        if(currentUserKey.elementsEqual(accident.user1Key)) {
            accidentUser2Key = accident.user2Key
        }
        else {
            accidentUser2Key = accident.user1Key
        }
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: accident.accidentLocationLat, longitude: accident.accidentLocationLong), preferredLocale: nil) { (clPlacemark: [CLPlacemark]?, error: Error?) in
            guard let place = clPlacemark?.first else {
                print("No placemark from Apple: \(String(describing: error))")
                return
            }
            let postalAddressFormatter = CNPostalAddressFormatter()
            postalAddressFormatter.style = .mailingAddress
            if let postalAddress = place.postalAddress {
                self.locationLbl.text = postalAddressFormatter.string(from: postalAddress)
            }
        }
        
        loadImages(imagesKey: accident.accidentPhotosKey)
        
        
    }
    
    private func loadImages(imagesKey: String) {
        let dict = FirebaseFunctions.getImagesForAccidentFirebase(imagesKey: imagesKey)
        for key in dict.keys {
            imagesUrlList.append(dict[key] as! String)
        }
    }
    
    private func checkPermission() {
        //check camera and library permission
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            self.showImagePickerControllerChooseSource()
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.showImagePickerControllerChooseSource()
                }
            }
            
        case .denied: // The user has previously denied access.
            return
            
        case .restricted: // The user can't grant access due to restrictions.
            return
        @unknown default:
            return
        }
    }
    
    @IBAction func otherDriverDetailsPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.otherDriverInfoVc, sender: sender)
    }
    
    @IBAction func addImagePressed(_ sender: Any) {
        showImagePickerControllerChooseSource()
        isUserAddingImage = true
        
        imagesCollection.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.accidentInfoToAddImageVc || segue.identifier == Constants.accidentInfoToImageDetVc) {
            let vc = segue.destination as! ImageViewController
            vc.accidentKey = accidentKey
            vc.imageUpload = imageUpload
            vc.didUserAddImage = isUserAddingImage
        }
        else if(segue.identifier == Constants.otherDriverInfoVc) {
            let vc = segue.destination as! OtherDriverInfoViewController
            vc.userUID = accidentUser2Key
        }
    }
}

extension AccidentInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesUrlList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.backgroundColor = UIColor.gray.cgColor
        cell.backgroundColor = UIColor.white
        cell.layer.shadowColor = UIColor.darkGray.cgColor
        
        let url = URL(string: imagesUrlList[indexPath.row])
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(data: data!)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = imagesUrlList[indexPath.item]
        let url = URL(string: item)
        let data = try? Data(contentsOf: url!)
        //set selected image to be presented
        self.imageUpload = UIImage(data: data!)
        isUserAddingImage = false
        
        performSegue(withIdentifier: Constants.accidentInfoToImageDetVc, sender: item)
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func delete(indexPaths: [IndexPath]) {
        imagesCollection.deleteItems(at: indexPaths)
        imagesCollection.reloadData()
    }
}

extension AccidentInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerChooseSource() {
        //alertController for choosing imagePicker sourceType
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
            
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else { return }
            }
        }
        let cameraAction = UIAlertAction(title: "Take from Camera", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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
        }
        if let originalImage = info[.originalImage] as? UIImage {
            imageUpload = originalImage
        }
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: Constants.accidentInfoToAddImageVc, sender: addImageBtn)
    }
}

