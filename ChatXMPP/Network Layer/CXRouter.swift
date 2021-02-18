//
//  CXRouter.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 18/02/21.
//

import Foundation
import HeadStart


public typealias NetworkRouterCompletion<T:Decodable> = (Result<T?, Error>) -> ()

protocol NetworkRouter: class
{
    associatedtype EndPoint: HSRequestSchema
    associatedtype T: Decodable
    
    func request(_ route: EndPoint, loadingView:UIView?, completion: @escaping NetworkRouterCompletion<T>)
    
    func cancel()
}

class CXRouter<EndPoint: HSRequestSchema, T: Decodable>: NetworkRouter {
   
    
    
    private var task: URLSessionTask?
    {
        didSet
        {
            guard let task = task else { return }
            
            DispatchQueue.main.async {
                if task.state == .running
                {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
                else
                {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    private var session:URLSession
    {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 180.0
        sessionConfig.timeoutIntervalForResource = 120.0
        sessionConfig.waitsForConnectivity = true
        
        let session = URLSession(configuration: sessionConfig)
        
        return session
    }
    
    func request(_ route: EndPoint, loadingView: UIView?, completion: @escaping NetworkRouterCompletion<T>) {
        
        
        do {
            let request = try self.buildRequest(from: route)
            
            // Log the response on the console
            HSNetworkLogger.log(request: request)
            
            
            guard let reachablility = Reachability(), reachablility.isReachable else {
                
                completion(.failure(HSNetworkResponse.networkFailed))
                return
            }
            
            task = self.session.dataTask(with: request) { (data, response, errors) in
                
                HSNetworkLogger.log(response: response)
                
                if let err =  errors
                {
                    completion(.failure(err))
                }
                else if let data = data, let response = response as? HTTPURLResponse
                {
                    let result = response.verifyResponse()
                    
                    switch result
                    {
                    case .success:
                            do
                            {
                                let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                                print(jsonData)

                                let apiResponse = try JSONDecoder().decode(T.self, from: data)
                                
                                let succ = apiResponse
                                
                                completion(.success(succ))
                            }
                            catch
                            {
                                completion(.failure(error))
                            }

                        break

                    case .failure:
                        
                        switch response.statusCode {
                        case 401:
                            
                            // logout of the application when status code : 403
                            
                            completion(.failure(HSNetworkResponse.authenticationError))
                            
//                            isLogin = false
//                            user = nil
//                            accessToken = nil
//                            isBiometricLogin = false
//                            appDelegate?.setUpInitialViewControllers()

                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logoutApp"), object: self)
                            
                            break
                            
                        default:
                            completion(.failure(HSNetworkResponse.badRequest))
                            break
                        }
                        
                            
                        break
                    }
                    
                   
                }
            }
            
            self.task?.resume()
        }
        catch
        {
            completion(.failure(error))
        }
    }
    
    func cancel()
    {
        session.finishTasksAndInvalidate()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                
                self.addAdditionalHeaders(route.headers, request: &request)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HSHTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}
