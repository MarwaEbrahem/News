//
//  favCategoriesCollectionViewCell.swift
//  NewsApp
//
//  Created by marwa on 12/16/21.
//  Copyright © 2021 marwa. All rights reserved.
//

import UIKit

class favCategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var favCategoriesLbl: UILabel!

    
    override var isSelected: Bool{
        didSet{
            favCategoriesLbl.textColor =  UIColor.gray
            favCategoriesLbl.backgroundColor =  #colorLiteral(red: 1, green: 0.720313144, blue: 0.6681106985, alpha: 1)

        }
    }
    
}
