////
////  MyJson.swift
////  CarApp
////
////  Created by Liel Titelbaum on 12/07/2020.
////  Copyright © 2020 Liel Titelbaum. All rights reserved.
////
//
//import Foundation
//
//class MyJson {
//    func convertProfileToJson(profile: Profile) -> String {
//        let jsonEncoder = JSONEncoder()
//        jsonEncoder.outputFormatting = .prettyPrinted
//        
//        let jsonData = try! jsonEncoder.encode(profile)
//        let json = String(data: jsonData, encoding: String.Encoding.utf8)!
//        
//        return json
//    }
//    
//    
//    // Decode
//    func convertJsonToList(json: String) -> Profile? {
//        let jsonDecoder = JSONDecoder()
//        if json != "" {
//            let profile: Profile
//            let convertedData: Data = json.data(using: .utf8)!
//            profile = try! jsonDecoder.decode(Profile.self,from: convertedData)
//            return profile
//        }
//        else{
//            return Profile()
//        }
//    }
//}
