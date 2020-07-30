//
//  File.swift
//  CarApp
//
//  Created by Liel Titelbaum on 24/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class UsefulMethods {
    
    public static func makePictureRound(image: UIImageView) {
        image.layer.borderWidth = 2
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
    
    public static func makeRedBorderToBtn (button: UIButton) {
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 1
    }
    
    public static func makeBtnRound(button: UIButton) {
        button.layer.cornerRadius = button.bounds.size.height/2
        button.clipsToBounds = true
    }
    
    public static func showImageFromUrl (imageUrl: String, profileImage: UIImageView) {
        //present the image from imageUrl in UIImageView
        print("starting to show image...")
        if(imageUrl == ""){
            print("url is empty")
            profileImage.image = #imageLiteral(resourceName: "blank_profile")
        }
        else {
            let url = URL(string: imageUrl) ?? nil
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                print("data url: \(String(describing: data))")
                DispatchQueue.main.async {
                    profileImage.image = UIImage(data: data!)
                }
            }
        }
    }
    
    public static func getAddressAsStringFromCord(long: Double, lat: Double, callBack: @escaping (_ location: String) -> ()) {
        //get longitude and latitude and return the location address
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude: long)) { (placemarks, error) in
            if let error = error {
                print("error in getting location from lat and lang \(error)")
                return
            }
            guard let placemark = placemarks?.first else {
                return
            }
            print("Getting location\n")
            let streetNubmer = placemark.subThoroughfare ?? ""
            print("street number \(streetNubmer)")
            let streetName = placemark.thoroughfare ?? ""
            print("street name \(streetName)")
            let cityName = placemark.locality ?? ""
            print("city name \(cityName)")
            
            DispatchQueue.main.async {
                callBack("\(streetName) \(streetNubmer) ,\(cityName)")
            }
        }
        callBack("")
    }
    
    public static func cameraLibPermissionsDenied(vc: UIViewController) {
        let alert = UIAlertController(title: "Opps! Camera and library access are dinied.", message: "Pleas go to Settings > CarApp to enable Camera and Photos access for this app.",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    public static func transitionToHomeScreen(vc: UIViewController) {
        let tabBarViewController = vc.storyboard?.instantiateViewController(identifier: Constants.tabBarVC) as? UITabBarController
        
        vc.dismiss(animated: false, completion: nil)
        vc.view.window?.rootViewController = tabBarViewController
        vc.view.window?.makeKeyAndVisible()
    }
}
