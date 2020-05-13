//
//  ProfileViewController.swift
//  FarmacyTracker
//
//  Created by Cristina Matei on 19/04/2020.
//  Copyright © 2020 Cristina-Gabriela Matei. All rights reserved.
//

import UIKit
import FirebaseAuth
import UserNotifications
import Firebase

struct Remainder {
    var id:String
    var title:String
    var datetime:DateComponents
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ref: DatabaseReference = Database.database().reference()
    var datesForRemainders:[String] = []
    var remainderMessages:[String] = []
    var numberOfRemainders: Int = 0
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var remaindersTable: UITableView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.remaindersTable.dataSource = self
        self.remaindersTable.delegate = self
        let user = Auth.auth().currentUser
        if let user = user {
            let userId = user.uid
            let manager = LocalNotificationManager()
            let photoURL = user.photoURL
            
            profilePicture.load(url: photoURL!)
            userName.text = user.displayName
            userEmail.text = user.email
            
            ref.child("userRemainders").observeSingleEvent(of: .value, with: { (snapshot) in
                let databaseValues = snapshot.value as? NSDictionary
                for (user, userRemainders) in databaseValues! {
                    if (user as! String == userId) {
                        let remainders = userRemainders as? NSDictionary
                        for (remainderId, remainderDetails) in remainders! {
                            let details = remainderDetails as? NSDictionary
                            let date = DateComponents(calendar: Calendar.current, year: details!["an"] as? Int, month: details!["luna"] as? Int, day: details!["zi"] as? Int, hour: details!["ora"] as? Int, minute: details!["minut"] as? Int)
                            manager.notifications.append(
                                Remainder(id: remainderId as! String, title: details!["mesaj"] as! String, datetime: date
                                    ))
                            self.datesForRemainders.append(self.turnDateComponentToString(date: date))
                            self.remainderMessages.append(details!["mesaj"] as! String)
                        }
                        self.numberOfRemainders = manager.notifications.count
                        manager.schedule()
                    }
                }
                self.remaindersTable.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func turnDateComponentToString(date: DateComponents) -> String {
        return "\(date.day!)/\(date.month!)/\(date.year!) \(date.hour!):\(date.minute!)";
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRemainders
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "remainderIdentifier", for: indexPath)
        configureCell(cell: cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAtIndexPath: IndexPath) {
        cell.textLabel?.text = "\(datesForRemainders[forRowAtIndexPath.row]):\r\n \(remainderMessages[forRowAtIndexPath.row])"
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.numberOfLines = 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
