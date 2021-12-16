//
//  ViewController.swift
//  NewsApp
//
//  Created by marwa on 12/15/21.
//  Copyright © 2021 marwa. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage

class HomeViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    var homeViewModelObj : HomeViewModelType?
    private let disposeBag = DisposeBag()
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
    var homeNews : [Dictionary<String,Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModelObj = HomeViewModel()
        searchBar.placeholder = "search for news"
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        homeViewModelObj?.dataDrive.drive(onNext: { [weak self] (newsData) in
            print(newsData.count)
            guard let self = self else { return }
            self.homeNews = newsData
            self.newsTableView.reloadData()
        }).disposed(by: disposeBag)
        searchBar.rx.text.orEmpty.debug().distinctUntilChanged().bind(to: homeViewModelObj!.searchValue).disposed(by: disposeBag)
        
        homeViewModelObj?.getNewsData()
    }
    
}
extension HomeViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        homeNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as!     homeNewsTableViewCell
        let news =  self.homeNews[indexPath.row] 
        cell.newsData = news
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             let details = self.storyboard?.instantiateViewController(identifier: "details") as! DetailsViewController
             details.newsDetails = self.homeNews[indexPath.row]
             self.navigationController?.pushViewController(details, animated: true)

         }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}

