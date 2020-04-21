//
//  ViewController.swift
//  FarmacyTracker
//
//  Created by Cristina Matei on 18/04/2020.
//  Copyright © 2020 Cristina-Gabriela Matei. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSignIn), name: NSNotification.Name("SuccessfulSignInNotification"), object: nil)
    }

    @objc func didSignIn()  {

        // Add your code here to push the new view controller
        print("got notif")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tabBar") as! TabBarViewController
        self.present(vc, animated: true, completion: nil)

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
