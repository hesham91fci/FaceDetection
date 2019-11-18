//
//  APIManager.swift
//  FaceDetection
//
//  Created by Hesham Ali on 11/17/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import Foundation
import Alamofire
class APIManager {
    private static var manager:SessionManager!
    private init(){
        
    }
    
    static func shared() -> SessionManager{
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "api.clarifai.com": .disableEvaluation
        ]
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 1000
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
         manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return manager
    }
    
}
