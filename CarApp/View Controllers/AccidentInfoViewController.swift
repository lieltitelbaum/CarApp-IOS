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
    private var imagesAmount = 0
    
    override func viewWillAppear(_ animated: Bool) {
        setUpCollectionView()
        loadAccidentDetails()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesCollection.allowsMultipleSelection = false
        UsefulMethods.makeBtnRound(button: addImageBtn)
        UsefulMethods.makeBtnRound(button: otherDriverDetailsBtn)
        UsefulMethods.makeRedBorderToBtn(button: addImageBtn)
        
        print("Accident key: \(accidentKey)")
        
        setUpCollectionViewItemSize()
    }
    
    private func setUpCollectionView() {
        imagesCollection.delegate = self
        imagesCollection.dataSource = self
    }
    
    private func setUpCollectionViewItemSize() {
        print("starting to set up collection view item size..")
        
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
        FirebaseFunctions.getAccidentFromFirebaseByKey(accidentKey: accidentKey) { (dict) in
            
            if dict.isEmpty == false {
                let accident = Accident.convertDictToAccidentObj(dict: dict)
                
                print("loaded dict accident")
                //                       print(loadedAccidentDict)
                print("accident date \(accident.accidentDate)")
                self.dateLbl.text = accident.accidentDate
                let currentUserKey:String = FirebaseFunctions.getCurrentUserUId()
                if(currentUserKey == accident.user1Key) {
                    self.accidentUser2Key = accident.user2Key
                }
                else {
                    self.accidentUser2Key = accident.user1Key
                }
                
                UsefulMethods.getAddressAsStringFromCord(long: accident.accidentLocationLong, lat: accident.accidentLocationLat) { (locationStr) in
                    self.locationLbl.text = locationStr
                }
                self.loadImages(imagesKey: accident.accidentPhotosKey)
            }
        }
    }
    
    private func loadImages(imagesKey: String) {
        
        FirebaseFunctions.getImagesForAccidentFirebase(imagesKey: imagesKey) { (imagesDict) in
            guard let imagesDict = imagesDict else {
                print("Images dict is empty")
                return
            }
            //if there are new images- > remove all url in the list, load url list and reload the data
            if(imagesDict.keys.count > self.imagesAmount && self.imagesUrlList.isEmpty == false) {
                self.imagesUrlList.removeAll()
                print("removing all")
                self.addUrlToList(imagesDict: imagesDict)
                self.imagesCollection.reloadData()
            }
            else if(self.imagesUrlList.isEmpty){
                self.addUrlToList(imagesDict: imagesDict)
                self.imagesCollection.reloadData()
            }
            
        }
        self.imagesAmount = self.imagesUrlList.count
       
    }

    private func addUrlToList(imagesDict: Dictionary< String, Any>){
    for key in imagesDict.keys {
        if(key != "url") {
            imagesUrlList.append(imagesDict[key] as! String)
            imagesUrlList.sort(by: {$0 > $1})
            print(imagesUrlList.count)
        }
    }
}
    
    private func checkPermission() {
        //check camera and library permission
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            print("in premission autorized")
            self.showImagePickerControllerChooseSource()
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    print("in premission requestAccess")
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
        checkPermission()
        isUserAddingImage = true
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.imageCollectionViewCellID, for: indexPath) as! ImageCollectionViewCell
        
        let url = URL(string: imagesUrlList[indexPath.row])
        print("url in collection view\(String(describing: url))")
        
        UsefulMethods.showImageFromUrl(imageUrl: imagesUrlList[indexPath.row], profileImage: cell.imageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = imagesUrlList[indexPath.item]
        let url = URL(string: item)
        let data = try? Data(contentsOf: url!)
        //set selected image to be presented
        self.imageUpload = UIImage(data: data!)
        isUserAddingImage = false
        
        performSegue(withIdentifier: Constants.accidentInfoToAddImageVc, sender: item)
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //    public func delete(indexPaths: [IndexPath]) {
    //        imagesCollection.deleteItems(at: indexPaths)
    //        imagesCollection.reloadData()
    //    }
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
        print("In accident info vc...")
        performSegue(withIdentifier: Constants.accidentInfoToAddImageVc, sender: addImageBtn)
    }
}

