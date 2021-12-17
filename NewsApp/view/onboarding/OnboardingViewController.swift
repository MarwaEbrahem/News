//
//  OnboardingViewController.swift
//  NewsApp
//
//  Created by marwa on 12/15/21.
//  Copyright © 2021 marwa. All rights reserved.
//

import UIKit
import DropDown
import RxCocoa
import RxSwift

class OnboardingViewController: UIViewController {
     private let disposeBag = DisposeBag()
    @IBOutlet weak var dropDownLbl: UILabel!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var favCategoriesCollectionView: UICollectionView!
    var country : [String] = []
    let dropDown = DropDown()
   
    var categoriesSelected : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
       favCategoriesCollectionView.delegate = self
        Observable.just(Constants.favCategories).bind(to: favCategoriesCollectionView.rx.items(cellIdentifier: "favCell")){
            row , item , cell in
            (cell as? favCategoriesCollectionViewCell)?.favCategoriesLbl.text = item
            
        }.disposed(by: disposeBag)
        
        favCategoriesCollectionView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] (value) in
            guard let self = self else { return }
            if self.categoriesSelected.contains(value) != true  {
                self.categoriesSelected.append(value)
            }
            
        }).disposed(by: disposeBag)
        
        country  = Array(Constants.countryCode.keys)
        dropDown.anchorView = dropDownView
        dropDown.dataSource = country
      
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)

        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .any

        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.dropDownLbl.text = self.country[index]
            UserDefaults.standard.set(Constants.countryCode[item], forKey: "countryName")
        }
    }

        
    
    @IBAction func goBtn(_ sender: Any) {
        if(UserDefaults.standard.value(forKey: "countryName") == nil || categoriesSelected.count == 0){
            
            let alert = UIAlertController(title: "Alert", message: "Choose country and favorite categories to continue", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            UserDefaults.standard.set(categoriesSelected, forKey: "favCategories")
            performSegue(withIdentifier: "toHome", sender: self)
        }
        
    }
    
    @IBAction func chooseCountry(_ sender: Any) {
        dropDown.show()
    }
}
extension OnboardingViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
            return CGSize(width: 170, height: 55)
    }

}
