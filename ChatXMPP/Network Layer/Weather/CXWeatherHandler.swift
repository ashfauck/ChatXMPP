//
//  CXWeatherHandler.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 18/02/21.
//

import Foundation
import HeadStart

class CXWeatherHandler
{
    static func getCityWeather(name: String, countryCode:String, completion: @escaping (Result<CXWeather,Error>) -> ())
    {
        CXRouter<CXWeatherEndpoint, CXWeather>().request(CXWeatherEndpoint.city(name: name, countryCode: countryCode), loadingView: nil) { (result) in
            
            switch result
            {
            case .success(let model):
                
                guard let mod = model else {
                    completion(.failure(HSNetworkResponse.noData))
                    return
                }
                
                completion(.success(mod))
                
                break
                
            case .failure(let error):
                print(error)
                completion(.failure(error))
                break
            }
            
        }
    }
}
