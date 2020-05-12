//
//  FarmaciesFoundViewController.swift
//  FarmacyTracker
//
//  Created by Cristina Matei on 19/04/2020.
//  Copyright © 2020 Cristina-Gabriela Matei. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FarmaciesFoundViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var farmaciesTable: UITableView!
    @IBOutlet weak var text: UILabel!
    var med: String = "";
    var ref: DatabaseReference = Database.database().reference()
    var farmaciesFound: [String] = []
    var lat: [Double] = []
    var long: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.farmaciesTable.dataSource = self
        self.farmaciesTable.delegate = self
        text.text = "You searched for " + med + ". Click on the farmacies below to see their position on the map"
        
        // Do any additional setup after loading the view.
        ref.child("farmacii").observeSingleEvent(of: .value, with: { (snapshot) in
            print("in ref farmacii")
            let databaseValues = snapshot.value as? NSDictionary
            print("value")
            print(databaseValues)
            for (farmacyName, farmacyDetails) in databaseValues! {
                print(farmacyName)
                let stock = (farmacyDetails as AnyObject)["stoc"]!!;
                print(stock)
                let stockMeds = (stock as AnyObject).allKeys as! [String]
                var medFound = false
                for medName in stockMeds {
                    if medName == self.med {
                        medFound = true
                    }
                }
                if (medFound) {
                    let address = (farmacyDetails as AnyObject)["adresa"]!! as! NSDictionary;
                    let addressLat = address["lat"] as! Double;
                    let addressLong = address["long"] as! Double
                    
                    self.farmaciesFound.append(farmacyName as! String)
                    self.lat.append(addressLat)
                    self.long.append(addressLong)
                } else {
                    print("not found")
                }
            }
            self.farmaciesTable.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("in did select row at")
        print(farmaciesFound)
        print(farmaciesFound.count)
        if indexPath.row < farmaciesFound.count {
            let selectedFarmacy = farmaciesFound[indexPath.row]
            
            let farmacyOnMapController = storyboard?.instantiateViewController(identifier: "farmacyOnMap") as! FarmacyOnMapViewController
            farmacyOnMapController.lat = self.lat[indexPath.row]
            farmacyOnMapController.long = self.long[indexPath.row]
            farmacyOnMapController.name = selectedFarmacy
            self.present(farmacyOnMapController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of rows in section")
        print(farmaciesFound.count)
        return farmaciesFound.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "farmacyCell", for: indexPath)
        configureCell(cell: cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAtIndexPath: IndexPath) {
        cell.textLabel?.text = farmaciesFound[forRowAtIndexPath.row]
        print("in for row at index path")
    }


}
