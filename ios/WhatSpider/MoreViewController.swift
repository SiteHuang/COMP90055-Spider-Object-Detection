//
//  MoreViewController.swift
//  WhatSpider
//
//  Created by Site on 12/1/19.
//  Copyright © 2019 Site. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage
import ColorThiefSwift
import SafariServices

class MoreViewController : UIViewController {
    
    @IBOutlet weak var webImageView: UIImageView!
    @IBOutlet weak var webImageDescription: UILabel!

    
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    var searchReqName = ""
//    var searchReqURL = "https://www.google.com"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestWIKI(requestName: requestName)
        self.navigationItem.title = requestName
    }
    
    
//    @IBAction func findMoreBtnTapped(_ sender: UIBarButtonItem) {
//        if searchReqName != ""{
//            let searchName = searchReqName.components(separatedBy: ",")[0]
//            searchReqURL = "https://www.google.com/search?q=\(searchName)"
//        } else {
//            searchReqURL = "https://www.google.com"
//        }
//        let svc = SFSafariViewController(url : URL(string: "https://www.google.com/search?q=\(searchReqURL)")!)
//        self.present(svc, animated: true, completion: nil)
//    }
    
    func requestWIKI(requestName: String) {
        searchReqName = requestName
        
        let parameters : [String:String] = ["format" : "json", "action" : "query", "prop" : "extracts|pageimages", "exintro" : "", "explaintext" : "", "titles" : requestName, "redirects" : "1", "pithumbsize" : "500", "indexpageids" : ""]
        
        // https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts|pageimages&exintro=&explaintext=&titles=barberton%20daisy&redirects=1&pithumbsize=500&indexpageids
        
        Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (response) in
            print("00000000000 Connection to WIKI established: \(response.result.isSuccess)")
            if response.result.isSuccess {
                let searchResultsJSON : JSON = JSON(response.result.value!)
                let pageid = searchResultsJSON["query"]["pageids"][0].stringValue
                
                let resultDescription = searchResultsJSON["query"]["pages"][pageid]["extract"].string
                let resultImageURL = searchResultsJSON["query"]["pages"][pageid]["thumbnail"]["source"].string
                
                if let setDescription = resultDescription {
                    self.webImageDescription.text = setDescription
                } else {
//                    print("Doesn't have a description")
                    if requestName != "WhatSpider"{
                        self.webImageDescription.text = "Could not get information from Wikipedia."
                    }
                }
                
                if let setURL = resultImageURL {
                    self.webImageView.sd_setImage(with: URL(string: setURL), completed: { (image, error,  cache, url) in
                        
                        if let currentImage = self.webImageView.image {
                            
                            guard let dominantColor = ColorThief.getColor(from: currentImage) else {
                                fatalError("Can't get dominant color")
                            }
                            
                            DispatchQueue.main.async {
                                self.navigationController?.navigationBar.isTranslucent = true
                                self.navigationController?.navigationBar.barTintColor = dominantColor.makeUIColor()
                            }
                        }
                        
                    })
                }else {
                    print("Doesn't have a URL")
                    self.webImageView.image = pickedImage
                }
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.webImageDescription.text = "Connection Issues"

            }
        }
    }
}
