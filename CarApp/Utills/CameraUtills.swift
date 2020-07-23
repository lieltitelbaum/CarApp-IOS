//
//  CameraUtills.swift
//  CarApp
//
//  Created by Liel Titelbaum on 23/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import AVFoundation
import Photos
import Foundation

class CameraUtills{
    
    static func checkPermission() {
           //check camera and library permission
          switch AVCaptureDevice.authorizationStatus(for: .video) {
              case .authorized: // The user has previously granted access to the camera.
                  self.presentPicker()
              
              case .notDetermined: // The user has not yet been asked for camera access.
                  AVCaptureDevice.requestAccess(for: .video) { granted in
                      if granted {
                          self.presentPicker()
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
}
