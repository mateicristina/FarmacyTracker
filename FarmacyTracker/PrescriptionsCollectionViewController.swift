//
//  PrescriptionsCollectionViewController.swift
//  FarmacyTracker
//
//  Created by Cristina Matei on 20/04/2020.
//  Copyright © 2020 Cristina-Gabriela Matei. All rights reserved.
//

import UIKit
import Photos
import Firebase

private let reuseIdentifier = "Cell"

class PrescriptionsCollectionViewController: UICollectionViewController {

    @IBOutlet var imageCollection: UICollectionView!
    var ref = Database.database().reference()
    var imageUrl: [URL] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        let user = Auth.auth().currentUser
        if let user = user {
            ref.child("userPrescriptions/\(user.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                let databaseValues = snapshot.value as? NSDictionary
                print("value")
                print(databaseValues)
                for (userId, urls) in databaseValues! {
                    print(urls)
                    self.imageUrl.append(urls as! URL)
                }
            })
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imageUrl.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "prescriptionImage", for: indexPath)
//        configureCell(cell: cell, forRowAtIndexPath: indexPath)
        // Configure the cell
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 50,y: 50, width: self.view.frame.width-200, height: 50))
        imageView.load(url: imageUrl[indexPath.row])
        cell.contentView.addSubview(imageView)
        return cell
    }
    
//    func configureCell(cell: UICollectionViewCell, forRowAtIndexPath: IndexPath) {
//        cell.backgroundView?.largeContentImage.load(url: imageUrl[forRowAtIndexPath.row])
//        print("in for row at index path")
//    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
