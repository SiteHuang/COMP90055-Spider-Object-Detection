//
//  DiscoverViewController.swift
//  WhatSpider
//
//  Created by Site on 12/1/19.
//  Copyright © 2019 Site. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase
import Photos


var pickedImage : UIImage?
var requestName : String = ""


class DiscoverViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var storage: Storage!
    var firestore: Firestore!
    
    @IBOutlet weak var discoverImageView: UIImageView!
    @IBOutlet weak var recogName: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var poisonousLabel: UILabel!
    
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        storage = Storage.storage()
        firestore = Firestore.firestore()
        requestName = "WhatSpider"
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pickedImage = userPickedImage
            self.accuracyLabel.text = ""
            self.poisonousLabel.text = ""
            if self.imagePicker.sourceType == .camera{
                UIImageWriteToSavedPhotosAlbum(userPickedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }else{
                self.recogName.text = "Waiting for uploading image to server..."
                self.discoverImageView.image = pickedImage
                let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
                let imageName = imageURL?.lastPathComponent
                let storageRef = storage.reference().child("images").child(imageName!)
                
                storageRef.putFile(from: imageURL!, metadata: nil) { metadata, error in
                    if let error = error {
                        self.recogName.text = "Upload Failed!"
                        print(error)
                    } else {
                        self.recogName.text = "Upload Successfully!"
                        print("upload success!")
                        
                        self.firestore.collection("predicted_images").document(imageName!)
                            .addSnapshotListener { documentSnapshot, error in
                                if let error = error {
                                    print("error occurred\(error)")
                                } else {
                                    if (documentSnapshot?.exists)! {
                                        let imageData = (documentSnapshot?.data())
                                        self.visualizePrediction(imgData: imageData)
                                    } else {
                                        self.recogName.text = "Waiting for prediction data..."
                                        print("waiting for prediction data...")
                                    }
                                }
                        }
                    }
                }
            }
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Please re-select the image from photo library to make detection.", preferredStyle: .alert)
            self.recogName.text = "Please re-select the image from photo library to make detection."
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    func visualizePrediction(imgData: [String: Any]?) {
//        print("11111111111")
//        print(imgData)
        let confidence = imgData!["confidence"] as! Double * 100
        let label_id = imgData!["label_name"] as! Int
        let recog_name = self.spiderID(id: label_id)
        requestName = self.wikiSearchID(id: label_id)
        let poisonousText = self.poisonousID(id: label_id)
        
        if (imgData!["image_path"] as! String).isEmpty {
            self.recogName.text = "No Spider found 😢"
            requestName = "Spiders of Australia"
        } else {
            let predictedImgRef = storage.reference(withPath: imgData!["image_path"] as! String)
            predictedImgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error)
                } else {
                    let image = UIImage(data: data!)
                    pickedImage = image
                    self.poisonousLabel.text = poisonousText
                    self.recogName.text = recog_name
                    self.accuracyLabel.text = "\(String(format: "%.2f", confidence))% confidence"
                    self.discoverImageView.image = image
                }
            }
        }
        
    }
    
    func spiderID(id: Int) -> String{
        switch id {
        case 1:
            return "Ant-mimicking Spider"
        case 2:
            return "Black House Spider"
        case 3:
            return "Flower Spider"
        case 4:
            return "Garden Orb-Weaving Spider"
        case 5:
            return "Huntsman Spider"
        case 6:
            return "Mouse Spider"
        case 7:
            return "Recluse Spider"
        case 8:
            return "☠️ Redback Spider"
        case 9:
            return "Saint Andrew\\'s Cross Spider"
        case 10:
            return "Spiny Spider"
        case 11:
            return "Spitting Spider"
        case 12:
            return "☠️ Funnel-Web Spider"
        case 13:
            return "Tarantula Spider"
        case 14:
            return "TrapDoor Spider"
        case 15:
            return "☠️ White-tailed Spider"
        case 16:
            return "Wolf Spider"
        case 17:
            return "Yellow Sac Spider"
        case 18:
            return "Ant"
        case 19:
            return "Crab"
        case 20:
            return "📷 Spider man!!"
        default:
            return "😢 No Spider found"
        }
    }
    
    func wikiSearchID(id: Int) -> String {
        switch id {
        case 1:
            return "Myrmarachne"
        case 2:
            return "Black House Spider"
        case 3:
            return "Misumena"
        case 4:
            return "Australian garden orb weaver spider"
        case 5:
            return "Huntsman Spider"
        case 6:
            return "Mouse Spider"
        case 7:
            return "Recluse Spider"
        case 8:
            return "Redback Spider"
        case 9:
            return "Argiope"
        case 10:
            return "Spiny orb-weaver"
        case 11:
            return "Spitting Spider"
        case 12:
            return "Australian funnel-web spider"
        case 13:
            return "Tarantula Spider"
        case 14:
            return "Trap Door Spiders"
        case 15:
            return "White tailed Spider"
        case 16:
            return "Wolf Spider"
        case 17:
            return "Yellow Sac Spider"
        case 18:
            return "Ant"
        case 19:
            return "Crab"
        case 20:
            return "Spiderman"
        default:
            return "Spiders of Australia"
        }
    }
    
    func poisonousID(id: Int) -> String{
        switch id {
        case 1,3,4,5,9,10,11,13:
            return "Low Risk. They are beneficial in the control of flies❤️"
        case 2,6,7,14,16,17:
            return "Poisonous. Bites may be painful. Be careful❗️"
        case 8,12,15:
            return "Deadly☠️ Get rid of it ASAP‼️"
        default:
            return ""
        }
    }
    
    @IBAction func camera(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
            print("User click Approve button")
        }))
        
        alert.addAction(UIAlertAction(title: "Choose From Album", style: .default , handler:{ (UIAlertAction)in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            print("User click Edit button")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        
        present(alert,animated: true)
    }
}
