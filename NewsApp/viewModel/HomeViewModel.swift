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
    var loadingObservable: Observable<Bool>
    var getNewsDataobj = NewsAPI.shared
    var localDataBaseObj = LocalDataManager.sharedInstance
    var dataSubject = PublishSubject<[Dictionary<String, Any>]>()
    var loadingSubject = PublishSubject<Bool>()
    var errorSubject = PublishSubject<Bool>()
    var searchValue : BehaviorRelay<String> = BehaviorRelay(value: "")
    private lazy var searchValueObservable:Observable<String> = searchValue.asObservable()
    private var data:[Dictionary<String,Any>]?
    private var disposeBag = DisposeBag()
    
    init(){
        loadingObservable = loadingSubject.asObserver()
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
        
        getNewsDataobj.getNews(country: UserDefaults.standard.value(forKey: "countryName") as! String, favCategory: "business") { (result) in
            switch result{
            case .success(let news):
                self.localDataBaseObj.addNewsToCoreData(news: news!) { (val) in
                    if(val){
                        self.localDataBaseObj.getNewsFromCoreData { (newsData) in
                            self.dataSubject.onNext(newsData)
                            self.data = newsData
                        }
                    }
                }
            case .failure(_):
                print("Error")
                self.errorSubject.onNext(true)
                
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
