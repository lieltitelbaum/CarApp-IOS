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
        
        getData()
    }
    
    private func getData() {
        //get all accident regarding current logged user
        FirebaseFunctions.getAllAccidentsFromFirebase { (arr) in
            if arr != nil {
                for accident in arr! {
                    print("accident key in list: \(accident.accidentKey)")
                    self.accidentsList.append(accident)
                }
                //sort by accident dates
                self.accidentsList.sort(by:  {$0.accidentDate > $1.accidentDate})
                DispatchQueue.main.async {
                    self.accidentsTableView.reloadData()
                }
            }
        }
        for accident in accidentsList {
            print(accident.accidentKey)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.moveToAccidentInfoVc) {
            let vc = segue.destination as! AccidentInfoViewController
            vc.accidentKey = accidentKey!
        }
    }
}

extension AccidentHistoryViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accidentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.accidentsTableView.dequeueReusableCell(withIdentifier: Constants.accidentRowIdHistoryVC, for: indexPath) as? AccidentHistoryTableViewCell
        
        //Add accident data to cell data
        cell?.dateLabel.text = self.accidentsList[indexPath.row].accidentDate
        accidentKey = self.accidentsList[indexPath.row].accidentKey
        let accidentLat = self.accidentsList[indexPath.row].accidentLocationLat
        let accidentLong = self.accidentsList[indexPath.row].accidentLocationLong
        
        UsefulMethods.getAddressAsStringFromCord(long: accidentLong, lat: accidentLat) { (locationStr) in
            cell?.locationLabel.text = locationStr
        }
        
        if (cell == nil){
            cell = AccidentHistoryTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: Constants.accidentRowIdHistoryVC)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        accidentKey = accidentsList[indexPath.row].accidentKey
        performSegue(withIdentifier: Constants.moveToAccidentInfoVc, sender: self)
    }
}

