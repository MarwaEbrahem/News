//
//  BaseAPI.swift
//  NewsApp
//
//  Created by marwa on 12/15/21.
//  Copyright © 2021 marwa. All rights reserved.
//

import Foundation
import Alamofire

class BaseAPI<T: TargetType> {
    
    func fetchData<M: Decodable>(target: T,responseClass: M.Type, completion:@escaping (Result<M?,NSError>)->()){
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let params = buildParams(task: target.task)
        
        AF.request(target.baseURL + target.path, method: method, parameters: params.0,encoding: params.1, headers: headers).responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else{
                completion(.failure(NSError()))
                return
            }
            
            if statusCode == 200 {
                guard let jsonResponse = try? response.result.get() else{
                    completion(.failure(NSError()))
                    return
                }
                guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                    completion(.failure(NSError()))
                    return
                }
                guard let responseObject = try? JSONDecoder().decode(M.self, from: jsonData) else {
                    completion(.failure(NSError()))
                    return
                }
                completion(.success(responseObject))
            }else{
                completion(.failure(NSError()))
            }
        }
    }
    
    
    
    private func buildParams(task:Task)->([String:Any], ParameterEncoding){
        switch task {
        case .requestPlain:
            return ([:],URLEncoding.default)
        case .requestParameters(parameters: let params, encoding: let encoding):
            return (params,encoding)
        }
    }
}
