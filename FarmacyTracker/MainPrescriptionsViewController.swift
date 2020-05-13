//
//  MainPrescriptionsViewController.swift
//  FarmacyTracker
//
//  Created by Cristina Matei on 13/05/2020.
//  Copyright © 2020 Cristina-Gabriela Matei. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Firebase

class MainPrescriptionsViewController: UIViewController {

    
    @IBOutlet weak var img: UIImageView!
    
    var ref = Database.database().reference()
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func onClickPickImage(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func saveImage(_ sender: Any) {
        var data = Data()
        data = img.image!.jpegData(compressionQuality: 0.8)!
        let uuid = UUID().uuidString;
        let imageRef = Storage.storage().reference().child("images/" + uuid)
        
        _ = imageRef.putData(data, metadata: nil) {(metadata, error) in
            guard let metadata = metadata else {
                return;
            }
            let size = metadata.size
            imageRef.downloadURL(completion:  {(url, error) in
                if let error = error {
                    return;
                } else {
                    let downloadURL: URL = url!;
                    print(downloadURL)
                    
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let uuid = UUID().uuidString; self.ref.child("userPrescriptions").child(user.uid).updateChildValues(["\(uuid)": downloadURL.absoluteString])
                    }
                }
            })
            
           
        }
        
    }
}

extension MainPrescriptionsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("in function")
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print("set the image")
            img.image = image
            print(image)
            print(img)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
