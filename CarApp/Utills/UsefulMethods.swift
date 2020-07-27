//
//  File.swift
//  CarApp
//
//  Created by Liel Titelbaum on 24/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit
import Foundation

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
    
    public static func showProfileImageFromUrl (imageUrl: String, profileImage: UIImageView) {
        if(imageUrl == ""){
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
}
