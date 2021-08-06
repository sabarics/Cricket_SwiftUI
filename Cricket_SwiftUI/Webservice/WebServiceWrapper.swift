//
//  WebServiceWrapper.swift
//  Cricket_SwiftUI
//
//  Created by Sabari on 31/07/21.
//

import Foundation
struct WebServiceWrapper {
    
    //1 creating the session
    let session: URLSession
    
    private init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    private init() {
        self.init(configuration: .default)
    }
    
    static let shared = WebServiceWrapper()
    
    typealias JSON = [String: AnyObject]
    typealias JSONTaskCompletionHandler = (Result<JSON>) -> ()
    
    func jsonGetTask(url:URL ,accesToken: String? = "", completionHandler completion: @escaping JSONTaskCompletionHandler) {
        
        var request = URLRequest(url: url)
        if let token = accesToken
        {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        self.session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session.configuration.urlCache = nil
        var task = URLSessionDataTask()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            task = self.session.dataTask(with: request) { (data, response, error) in
                
                DispatchQueue.main.async(execute: {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(.Error(.requestFailed))
                        return
                    }
                    
                    if httpResponse.statusCode == 200 {
                        
                        if let data = data {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                                    DispatchQueue.main.async {
                                        completion(.Success(json))
                                    }
                                }
                            } catch {
                                completion(.Error(.jsonConversionFailure))
                            }
                        } else {
                            completion(.Error(.invalidData))
                        }
                    }
                    else if httpResponse.statusCode == 400 || httpResponse.statusCode == 401
                    {
                        
                        if let data = data {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                                    DispatchQueue.main.async {
                                        completion(.ApiError(json as! [String : String]))
                                    }
                                }
                            } catch {
                                completion(.Error(.jsonConversionFailure))
                            }
                        } else {
                            completion(.Error(.invalidData))
                        }
                    }
                    else {
                        if let data = data {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                                    DispatchQueue.main.async {
                                        completion(.ApiError(json as [String : Any]))
                                    }
                                }
                            } catch {
                                completion(.Error(.jsonConversionFailure))
                            }
                        } else {
                            completion(.Error(.invalidData))
                        }
                    }
                })
            }
            task.resume()
        }
    }
    
    func jsonPostTask(url:URL ,accesToken: String?,postData:[String:Any],method:String, completionHandler completion: @escaping JSONTaskCompletionHandler)  {
        
        var request = URLRequest(url: url)
        if let token = accesToken
        {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpMethod = method
        self.session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session.configuration.urlCache = nil
        if postData.count > 0
        {
            let jsonData = try? JSONSerialization.data(withJSONObject: postData)
            request.httpBody = jsonData
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var task = URLSessionDataTask()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            task = self.session.dataTask(with: request) { (data, response, error) in
                
                DispatchQueue.main.async(execute: {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(.Error(.requestFailed))
                        return
                    }
                    
                    if httpResponse.statusCode == 200 {
                        
                        if let data = data {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                                    DispatchQueue.main.async {
                                        completion(.Success(json))
                                    }
                                }
                            } catch {
                                completion(.Error(.jsonConversionFailure))
                            }
                        } else {
                            completion(.Error(.invalidData))
                        }
                    }
                    else if httpResponse.statusCode == 400 ||  httpResponse.statusCode == 401
                    {
                        
                        if let data = data {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                                    DispatchQueue.main.async {
                                        completion(.ApiError(json as [String : Any]))
                                    }
                                }
                            } catch {
                                completion(.Error(.jsonConversionFailure))
                            }
                        } else {
                            completion(.Error(.invalidData))
                        }
                    }
                    else if (httpResponse.statusCode == NSURLErrorCancelled || httpResponse.statusCode == NSURLErrorTimedOut || httpResponse.statusCode == NSURLErrorCannotConnectToHost || httpResponse.statusCode == NSURLErrorNetworkConnectionLost || httpResponse.statusCode == NSURLErrorNotConnectedToInternet || httpResponse.statusCode == NSURLErrorInternationalRoamingOff || httpResponse.statusCode == NSURLErrorCallIsActive || httpResponse.statusCode == NSURLErrorDataNotAllowed)
                    {
                        completion(.Error(.offline))
                    }
                    else {
                        if let data = data {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                                    DispatchQueue.main.async {
                                        completion(.ApiError(json as [String : Any]))
                                    }
                                }
                            } catch {
                                completion(.Error(.jsonConversionFailure))
                            }
                        } else {
                            completion(.Error(.invalidData))
                        }
                    }
                })
            }
            task.resume()
        }
        
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?) -> Void)
    {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            URLSession.shared.dataTask(with: url) {(data, response, error) in
                DispatchQueue.main.async(execute: {
                    if data != nil
                    {
                        if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
                        {
                            completion(data)
                        }
                        else
                        {
                            completion(nil)
                        }
                    }
                    else
                    {
                        completion(nil)
                    }
                })
            }.resume()
        }
    }
    
    
}


enum Result <T>{
    case Success(T)
    case Error(ApiResponseError)
    case ApiError([String:Any])
}

enum ApiResponseError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case invalidURL
    case jsonParsingFailure
    case offline
    
}





