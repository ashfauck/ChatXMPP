//
//  CXWeatherEndpoint.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 18/02/21.
//

import Foundation
import HeadStart

enum CXWeatherEndpoint
{
    case city(name: String, countryCode: String)
}


extension CXWeatherEndpoint: HSRequestSchema
{
    var baseURL: URL
    {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/") else { fatalError("URL not constructed") }
        return url
    }
    
    var path: String
    {
        switch self
        {
        case .city:
            return "weather"
        }
    }
    
    var httpMethod: HSHttpMethod
    {
        switch self
        {
        case .city:
            return .post
        }
    }
    
    var task: HSRequestTaskType
    {
        switch self
        {
        case .city(let name, let countryCode):
            
            let cityDict = ["q":"\(name),\(countryCode)", "appid": OpenWeatherAppKey, "units":"metric"]
            
            return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: cityDict, additionHeaders: headers)
        }
    }
    
    var headers: HSHTTPHeaders?
    {
        return ["Content-Type": "application/json"]
    }
}
