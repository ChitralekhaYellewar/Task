//
//  ServiceHandler.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import Alamofire

class ServiceHandler {
    
    //MARK: - Variables
    typealias Response = Any?
    typealias complete = (Response) -> Void
    typealias failed = (Error) -> Void
    
    //MARK: - Methods
    //MARK: - Public Methods
    
    public static func request(endPoint: String,
                               requestMethod:String,
                               requestParameters:[String:Any]?,
                               httpHeaders:[String: String]?,
                               completionHandler: @escaping complete,
                               failureHandler: @escaping failed) {
        
        #if DEBUG
        print("\n Request URL: \(requestMethod) -> \(endPoint)")
        #endif
        
        let method = self.getHttpMethod(type: requestMethod)
        
        //Alamofire call to fetch data
        Alamofire.request(endPoint, method: method, parameters: requestParameters, encoding: JSONEncoding.default, headers: httpHeaders).validate{ _, _, _ in
            return .success
            }.responseJSON { response in
                
                #if DEBUG
                print("Response: \(String(describing: response.result.value))")
                #endif
                
                if response.response?.statusCode == 200 {
                    guard let result = response.result.value else {
                        completionHandler(nil)
                        return
                    }
                    if !(response.result.error != nil) {
                        completionHandler(result)
                    }
                } else if response.response?.statusCode == 401 { // status with 401 unauthorized
                    
                    let alert = UIAlertController(title: Defaults.error, message: Defaults.emptyString,
                                                  preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: Defaults.okButtonTitle, style: .default, handler: { (_) in
                        alert.dismiss(animated: true, completion: nil)
                        //
                    }))
                    
                    UIViewController.topMostViewController?.present(alert, animated: true, completion: nil)
                    
                }
        }
        
    }
    
    
    //MARK: - Private methods
    //MARK: - Get service method type
    
    private static func getHttpMethod(type: String) -> HTTPMethod {
        var method: HTTPMethod = .get
        switch type {
        case RequestMethods.get:
            method = .get
        default:
            break
        }
        return method
    }
}

// Server request methods

struct RequestMethods {
    static let get = "GET"
}

