//
//  CXWeatherViewModel.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 18/02/21.
//

import Foundation

class CXWeatherViewModel: NSObject
{
    
    var didUpdateLoading:((_ success:Bool)->())?
    var alertMessage:((_ message:String)->())?
    var updateUI:(()->())?
    
    let group = DispatchGroup()

    var weathers:[CXWeather] = []
    
    func getApi()
    {
        
        self.getWeather(name: "chennai", code: "IN")
        self.getWeather(name: "delhi", code: "IN")
        self.getWeather(name: "mumbai", code: "IN")
        self.getWeather(name: "hyderabad", code: "IN")
        
        self.group.notify(queue: .main) {
            self.updateUI?()
        }
    }
    
    func getWeather(name: String, code: String)
    {
        self.didUpdateLoading?(true)
        
        self.group.enter()

        CXWeatherHandler.getCityWeather(name: name, countryCode: code, completion: { (result) in
            
            self.group.leave()
            
            self.didUpdateLoading?(false)
            
            switch result
            {
                
            case .success(let model):
                
                DispatchQueue.main.async {
                    self.weathers.append(model)
                }
                                
                break
                
            case .failure(let error):
                
                print(error)
                break
            }
        })
    }
    
}
