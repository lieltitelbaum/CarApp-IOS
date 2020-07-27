//
//  ScannerViewController.swift
//  CarApp
//
//  Created by Liel Titelbaum on 12/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import AVFoundation
import UIKit
import CoreLocation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    private var accidentKey: String = ""
    @IBOutlet weak var demoBtn: UIButton!
    @IBOutlet weak var scanBtn: UIButton!
    //lcations vars
    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    private var isUpdatingLocation: Bool = false
    private var lastLocationError: Error?
    private var isPermission: Bool = false
    private var didGetLocation: Bool = false
    var locationLat:Double = 0
    var locationLong:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isPermission = findLocation()
        startLocationManager()
        
        UsefulMethods.makeBtnRound(button: demoBtn)
        UsefulMethods.makeBtnRound(button: scanBtn)
    }
    
    func startScanning() {
        DispatchQueue.main.async {
            self.view.backgroundColor = UIColor.black
            self.captureSession = AVCaptureSession()
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
            let videoInput: AVCaptureDeviceInput
            
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }
            
            if (self.captureSession.canAddInput(videoInput)) {
                self.captureSession.addInput(videoInput)
            } else {
                self.failed()
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (self.captureSession.canAddOutput(metadataOutput)) {
                self.captureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                self.failed()
                return
            }
            
            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.previewLayer.frame = self.view.layer.bounds
            self.previewLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(self.previewLayer)
            
            self.captureSession.startRunning()
        }
    }
    
    func getCurrentLocation(userID: String) {
        if(isPermission && didGetLocation){
            //if user granted location permission, get his location, if not set default location to 0,0
            locationLong = location?.coordinate.longitude ?? 0
            locationLat = location?.coordinate.latitude ?? 0
            print("Lat: \(locationLat)")
            print("Long: \(locationLong)")
            
            createAccident(userID: userID)
        }
    }
    
    func createAccident(userID: String){
        let accidentUniqeKey = UUID().uuidString
        let user2 = FirebaseFunctions.getCurrentUserUId()
        accidentKey = accidentUniqeKey + "_ " + userID + "_" + user2 //create key that contains both users keys
        print("My user uid: \(user2) other driver uid: \(userID)")
        FirebaseFunctions.createAccidentInFirestore(accident: Accident(accidentKey: accidentKey, user1Key: userID, user2Key: user2, accidentLocationLat: locationLat, accidentLocationLong: locationLong, accidentPhotosKey: accidentKey))
        
        self.performSegue(withIdentifier: Constants.accidentDetailsFromScanner, sender: self)
    }
    
    func startLocationManager() {
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            isUpdatingLocation = true
        }
    }
    
    func stopLocationManager() {
        if isUpdatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            isUpdatingLocation = false
        }
    }
    
    func findLocation() -> Bool//premisions
    {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return true
        }
        if authStatus == .denied || authStatus == .restricted {
            reportLocationServicesDenied()
            return false
        }
        return true
    }
    
    func  reportLocationServicesDenied() {
        let alert = UIAlertController(title: "Opps! location services are disabled.", message: "Pleas go to Settings > Privacy to enable location services for this app.",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            self.startScanning()
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.startScanning()
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
    
    func found(code: String) {
        //add accident to firebase
        print(code)
        getCurrentLocation(userID: code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func demoPressed(_ sender: Any) {
        //create accident with user id- PnIIpfQEzmWvWtyobeDIMoApKa13 , name: liel titel
        //        createAccident(userID: "PnIIpfQEzmWvWtyobeDIMoApKa13")
        getCurrentLocation(userID: "PnIIpfQEzmWvWtyobeDIMoApKa13")
    }
    
    @IBAction func scanPressed(_ sender: Any) {
        checkPermission()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.accidentDetailsFromScanner) {
            let vc = segue.destination as! AccidentInfoViewController
            vc.accidentKey = accidentKey
        }
    }
}

extension ScannerViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR!! locationManager-didFailedWithError: \(error)")
        if(error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        
        lastLocationError = error
        stopLocationManager()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        location = locations.last!
        didGetLocation = true
        stopLocationManager()
        
        print("GOT IT! locationManager-didUpdateLocation: \(String(describing: location))")
    }
    
}

