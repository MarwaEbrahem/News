//
//  OnboardingViewController.swift
//  NewsApp
//
//  Created by marwa on 12/15/21.
//  Copyright © 2021 marwa. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var countryNameTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func goBtn(_ sender: Any) {
        UserDefaults.standard.set(countryNameTxt.text, forKey: "countryName")
        performSegue(withIdentifier: "toHome", sender: self)
    }
    
}
