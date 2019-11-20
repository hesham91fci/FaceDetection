//
//  Constants.swift
//  FaceDetection
//
//  Created by Hesham Ali on 11/17/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import Foundation
struct Environment {
    struct ProductionServer {
        static let baseURL = "https://api.clarifai.com/v2/"
    }
    
    struct APIParameterKey {
        static let inputs = "inputs"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json; charset=utf-8"
}

enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
}

struct UserDefaultsKeys {
    static let pictures = "pictures"
}

