//
//  AccidentViewModel.swift
//  CarApp
//
//  Created by Liel Titelbaum on 18/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import Foundation
import FirebaseFirestore

class AccidentViewModel {
    
    var accidents = [Accident]()
    
func fetchAccidents() {
//    FirebaseFunctions.db.collection(Constants.fireStoreDbAccident).addSnapshotListener { (querySnapshot, error) in
//           guard let documents = querySnapshot?.documents else {
//               print("No documents")
//               return
//           }
//           var accidents = documents.map { (queryDocumentSnapshot) -> Accident in
//               let data = queryDocumentSnapshot.data()
//
//            let accidentDate = data[DictKeyConstants.accidentDate] as! String?
//            let accidentUser1 = data[DictKeyConstants.accidentUser1] as! Dictionary<String, Any>
//            let accidentUser2 = data[DictKeyConstants.accidentUser2] as! Dictionary<String, Any>
//            let accidentLocation = data[DictKeyConstants.accidentLocation] as! Dictionary<String, Any>
//            let accidentImages = data[DictKeyConstants.accidentPhotos] as! Dictionary<String, Any>
//            let accidentKey = data[DictKeyConstants.accidentKey] as! String
//
//            return Accident(key: accidentKey ?? "", user1: accidentUser1, user2: accidentUser2, date: accidentDate ?? "", accidentLocation: accidentLocation ?? "", photos: accidentImages)
//        }
//           }
//       }
    }
}
