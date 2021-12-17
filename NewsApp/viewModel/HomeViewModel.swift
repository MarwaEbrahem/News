//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by marwa on 12/15/21.
//  Copyright © 2021 marwa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel : HomeViewModelType{
   
    var dataDrive: Driver<[Dictionary<String, Any>]>
    var errorObservable: Observable<Bool>
    var getNewsDataobj = NewsAPI.shared
    var localDataBaseObj = LocalDataManager.sharedInstance
    var dataSubject = PublishSubject<[Dictionary<String, Any>]>()
    var errorSubject = PublishSubject<Bool>()
    var searchValue : BehaviorRelay<String> = BehaviorRelay(value: "")
    private lazy var searchValueObservable:Observable<String> = searchValue.asObservable()
    private var data:[Dictionary<String,Any>]?
    private var disposeBag = DisposeBag()
    
    init(){
        errorObservable = errorSubject.asObserver()
        dataDrive = dataSubject.asDriver(onErrorJustReturn: [])
        searchValueObservable.subscribe(onNext: {[weak self] (value) in
            print("value is \(value)")
            guard let self = self else {return}
            let filteredData = self.data?.filter({ (news) -> Bool in
                return (news["title"] as? String ?? " ").lowercased().contains(value.lowercased())
            })
            if (value.count == 0){
                self.dataSubject.onNext(self.data ?? [])
            }else{
                self.dataSubject.onNext(self.sortNewsByDate(news: filteredData ?? []))
            }
            
        }).disposed(by: disposeBag)
    }
    
    
    func sortNewsByDate(news : [Dictionary<String,Any>]) -> [Dictionary<String,Any>]{
        var filteredNews = news
        filteredNews.sort { (firstItem, secondItem) -> Bool in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let dateAString = firstItem["published"] as? String,
                let dateBString = secondItem["published"] as? String,
                let dateA = dateFormatter.date(from: dateAString),
                let dateB = dateFormatter.date(from: dateBString){
                return dateA.compare(dateB) == .orderedAscending
            }
            return false
        }
        return filteredNews
    }
    
    func getNewsData() {
        self.localDataBaseObj.getNewsFromCoreData { (result) in
            if(result.count == 0){
                self.fetchNews()
            }else{
                self.dataSubject.onNext(result)
                self.data = result
            }
            self.reloadNewsData()
        }
    }

    @objc func fetchNews() {
        if(!Connectivity.isConnectedToInternet){
            errorSubject.onNext(true)
                return
        }
        let arr = UserDefaults.standard.value(forKey: "favCategories") as? [String]
        
        var totalArticle : [Article] = []
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "Queue", qos: .userInteractive)
        for item in arr ?? [] {
            dispatchGroup.enter()
            dispatchQueue.async {
                self.getNewsDataobj.getNews(country: UserDefaults.standard.value(forKey: "countryName") as! String, favCategory: item) { (result) in
                    switch result{
                    case .success(let news):
                        print("get \(item)")
                        totalArticle.append(contentsOf: news!.articles)
                        dispatchGroup.leave()
                    case .failure(_):
                        print("Error")
                        self.errorSubject.onNext(true)
                        dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.localDataBaseObj.addNewsToCoreData(articles: totalArticle) { (val) in
                if(val){
                    self.localDataBaseObj.getNewsFromCoreData { (newsData) in
                        self.dataSubject.onNext(newsData)
                        print("get data complete")
                        self.data = newsData
                    }
                }
            }
        }
    }
    
    func reloadNewsData(){
        Timer.scheduledTimer(timeInterval: 1800,
            target: self,
            selector: #selector(fetchNews),
            userInfo: nil,
            repeats: true)
    }
    
    

}
