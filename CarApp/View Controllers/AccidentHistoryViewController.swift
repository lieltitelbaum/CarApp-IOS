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

class AccidentHistoryViewController: UIViewController {

    @IBOutlet weak var accidentsTableView: UITableView!
    var accidentKey: String? = ""
    
    var accidentsList = [Accident]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func convertDictTolist(){
//        var dict:Dictionary<String, Any> = FirebaseFunctions.getAccidentsFromFirebase()
//        for accidentKey in dict.keys {
//            accidentsList.append(dict[accidentKey] as! Accident)
//        }
    }
    
    @IBAction func moreInfoTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.moveToAccidentInfoVc, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.moveToAccidentInfoVc) {
            let vc = segue.destination as! AccidentInfoViewController
            vc.accidentKey = accidentKey!
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
        var cell = self.accidentsTableView.dequeueReusableCell(withIdentifier: "AccidentRow", for: indexPath) as? AccidentHistoryTableViewCell
        
        let lat = self.accidentsList[indexPath.row].accidentLocationLat
        let longi = self.accidentsList[indexPath.row].accidentLocationLong
        let address = CLGeocoder.init()
        accidentKey = self.accidentsList[indexPath.row].accidentKey
        
        
        address.reverseGeocodeLocation(CLLocation.init(latitude: lat, longitude:longi)) { (places, error) in
            if error == nil{
                if let place = places{
                    //here you can get all the info by combining that you can make address
                }
            }
        }
//        cell?.index_in_row.text = "\(indexPath.row + 1))"
//        cell?.playerName.text = self.highScores[indexPath.row].playerName
//        cell?.dateTime.text = self.highScores[indexPath.row].gameDate
//        cell?.score.text = "\(self.highScores[indexPath.row].score)"
        
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

