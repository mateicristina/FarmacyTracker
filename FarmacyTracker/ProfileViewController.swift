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

class ProfileViewController: UIViewController {

    var ref: DatabaseReference = Database.database().reference()
    var dates:[DateComponents] = []
    var remainderMessages:[String] = []
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in right controller")
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
                        print("am gasit userul")
                        print(userRemainders)
                        let remainders = userRemainders as? NSDictionary
                        for (remainderId, remainderDetails) in remainders! {
                            let details = remainderDetails as? NSDictionary
                            manager.notifications.append(
                                Remainder(id: remainderId as! String, title: details!["mesaj"] as! String, datetime:
                                    DateComponents(calendar: Calendar.current, year: details!["an"] as? Int, month: details!["luna"] as? Int, day: details!["zi"] as? Int, hour: details!["ora"] as? Int, minute: details!["minut"] as? Int)))
                        }
                        manager.schedule()
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
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

class LocalNotificationManager
{
    var notifications = [Remainder]()
    
    func listScheduledNotifications()
    {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in

            for notification in notifications {
                print(notification)
            }
        }
    }
    
    func schedule()
    {
        UNUserNotificationCenter.current().getNotificationSettings { settings in

            print("settings")
            print(settings)
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break // Do nothing
            }
        }
    }
    
    private func scheduleNotifications()
    {
        for notification in notifications
        {
            let content      = UNMutableNotificationContent()
            content.title    = notification.title
            content.sound    = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)

            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in

                guard error == nil else { return }

                print("Notification scheduled! --- ID = \(notification.id)")
            }
        }
    }

}
