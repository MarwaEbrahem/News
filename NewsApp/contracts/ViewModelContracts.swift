//
//  ViewModelContracts.swift
//  NewsApp
//
//  Created by marwa on 12/15/21.
//  Copyright © 2021 marwa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType{
    var errorObservable: Observable<Bool> {get}
    
}
protocol HomeViewModelType : ViewModelType {
    var dataDrive : Driver<[Dictionary<String, Any>]> {get}
    func getNewsData()
    var searchValue : BehaviorRelay<String> {get}
    
}
