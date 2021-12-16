//
//  homeNewsTableViewCell.swift
//  NewsApp
//
//  Created by marwa on 12/15/21.
//  Copyright © 2021 marwa. All rights reserved.
//

import UIKit
import SDWebImage

class homeNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    var newsData:Dictionary<String,Any>!{
        didSet{
            newsDescription.text = newsData["title"] as? String
            newsImage.sd_setImage(with: URL(string: newsData["urlToImage"] as? String ?? " "), placeholderImage: UIImage(named:"1"))
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
