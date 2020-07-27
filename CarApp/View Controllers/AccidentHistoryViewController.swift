//
//  AccidentHistoryViewController.swift
//  CarApp
//
//  Created by Liel Titelbaum on 15/07/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Contacts

class AccidentHistoryViewController: UIViewController {

    @IBOutlet weak var accidentsTableView: UITableView!
    var accidentKey: String? = ""
    
    var accidentsList = [Accident]()
    var locationDesc:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accidentsTableView.dataSource = self
        accidentsTableView.delegate = self
        
        FirebaseFunctions.getAllAccidentsFromFirebase { (arr) in
            if arr != nil {
                for accident in arr! {
                    print("accident key in list: \(accident.accidentKey)")
                    self.accidentsList.append(accident)
                }
                self.accidentsTableView.reloadData()
            }
        }
        for accident in accidentsList {
            print(accident.accidentKey)
        }
        accidentsTableView.reloadData()
    }
    
    @IBAction func moreInfoTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.moveToAccidentInfoVc, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.moveToAccidentInfoVc) {
            let vc = segue.destination as! AccidentInfoViewController
            vc.accidentKey = accidentKey!
            vc.locationStr = locationDesc
        }
    }
}


//extension AccidentHistoryViewController : CLLocationManagerDelegate
//{
////    func createPinPointOnMap(location: Location,title: String){
////        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
////        mkAnnotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
////        mkAnnotation.title = title
////        mapView.addAnnotation(mkAnnotation)
////    }
//
//    func createRegion(location:Location){
//        let mRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude,longitude: location.longitude),latitudinalMeters: 1000, longitudinalMeters: 1000)
////        mapView.setRegion(mRegion, animated: true)
//    }
//
//}

extension AccidentHistoryViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accidentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //todo-> make identifier const
        var cell = self.accidentsTableView.dequeueReusableCell(withIdentifier: "AccidentRow", for: indexPath) as? AccidentHistoryTableViewCell
        
        cell?.dateLabel.text = self.accidentsList[indexPath.row].accidentDate
        
        accidentKey = self.accidentsList[indexPath.row].accidentKey
        
        let accidentLat = self.accidentsList[indexPath.row].accidentLocationLat
          let accidentLong = self.accidentsList[indexPath.row].accidentLocationLong
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: accidentLat, longitude: accidentLong)) { (placemarks, error) in
//            guard let self = self else{return}
            if let _ = error {
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
            
//            DispatchQueue.main.async {
                self.locationDesc = "\(streetName) \(streetNubmer) ,\(cityName)"
                cell?.locationLabel.text = self.locationDesc
                print(self.locationDesc)
//            }
//            cell?.reloadInputViews()
//            self.accidentsTableView.reloadData()
        }
        
//        createPinPointOnMap(location: self.highScores[indexPath.row].gameLocation, title: self.highScores[indexPath.row].gameDate)
//
        if (cell == nil){
            cell = AccidentHistoryTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "AccidentRow")
        }
        
        return cell!
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        createRegion(location: self.highScores[indexPath.row].gameLocation)
//    }
    
}

