//
//  AddRemainderViewController.swift
//  FarmacyTracker
//
//  Created by Cristina Matei on 13/05/2020.
//  Copyright © 2020 Cristina-Gabriela Matei. All rights reserved.
//

import UIKit
import Firebase

class AddRemainderViewController: UIViewController {

    @IBOutlet weak var remainderDate: UIDatePicker!
    @IBOutlet weak var remainderMessage: UITextField!
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let message: String = self.remainderMessage.text!
        print("message")
        print(message)
        
        let date = remainderDate.date
        print("date")
        print(date)
        
        // Get date picker data
        let components = remainderDate.calendar.dateComponents([.day, .month, .year, .hour, .minute], from: remainderDate.date)
        print(components)
        print(type(of: components))
        let day = components.day!
        let month = components.month!
        let year = components.year!
        let hour = components.hour!
        let minute = components.minute!
        print(day)
        print(month)
        print(year)
        print(hour)
        print(minute)
       
       let user = Auth.auth().currentUser
        if let user = user {
            let uuid = UUID().uuidString; self.ref.child("userRemainders").child(user.uid).updateChildValues(["\(uuid)": [
                "an": year,
                "luna": month,
                "zi":day,
                "ora":hour,
                "minut":minute,
                "mesaj": message
            ]])
        }
    }

}
