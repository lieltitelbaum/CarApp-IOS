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
    
    public static func makeProfilePictureRound(image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
    
    public static func showProfileImageFromUrl (imageUrl: String, profileImage: UIImageView) {
        let url = URL(string: imageUrl)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                profileImage.image = UIImage(data: data!)
            }
        }
    }
}
