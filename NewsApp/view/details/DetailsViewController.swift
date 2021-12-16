//
//  DetailsViewController.swift
//  NewsApp
//
//  Created by marwa on 12/15/21.
//  Copyright © 2021 marwa. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsAuther: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    var newsDetails : Dictionary<String,Any>?
    override func viewDidLoad() {
        super.viewDidLoad()

        let articleBarButtonItem = UIBarButtonItem(title: "Open Article", style: .done, target: self, action: #selector(openArticle))
           self.navigationItem.rightBarButtonItem  = articleBarButtonItem
        
        
        guard let newsDetails = newsDetails else {return}
        newsTitle.text = newsDetails["title"] as? String
        newsAuther.text = newsDetails["auther"] as? String
        newsDescription.text = newsDetails["description"] as? String
        newsImage.sd_setImage(with: URL(string: newsDetails["urlToImage"] as! String), placeholderImage: UIImage(named:"1"))
    }
    
    @objc func openArticle() {
        guard let newsDetails = newsDetails else {return}
        guard let url = URL(string: newsDetails["url"] as? String ?? " ") else {return}
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
   

}
