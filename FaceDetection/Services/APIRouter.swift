//
//  APIRouter.swift
//  FaceDetection
//
//  Created by Hesham Ali on 11/17/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import Foundation
import Alamofire
enum APIRouter: URLRequestConvertible {
    
    
    case detectFaces(image:UIImage)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .detectFaces:
            return .post
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .detectFaces:
            return "models/a403429f2ddf4b49b307e318f00e528b/outputs"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        func convertToDictionary(text:String)->[String:Any]?{
            if let data = text.data(using: .utf8) {
                do {
                    return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } catch {
                    print(error.localizedDescription)
                }
            }
            return nil
        }
        switch self {
        case .detectFaces(let image):
            let base64Image = (image.jpegData(compressionQuality: 0.25)?.base64EncodedString()) ?? ""
            let imageObj = Image(base64: base64Image)
            let dataObj = DataClass(image: imageObj)
            let inputObj = Input(data: dataObj)
            let inputsContainerObj = FaceInput(inputs: [inputObj])
            
            let encoder = JSONEncoder()
            do {
                let jsonData = try encoder.encode(inputsContainerObj)
                
                return convertToDictionary(text: String(data: jsonData, encoding: .utf8)!)
                
            } catch _ as NSError {
                return nil
            }
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Environment.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.addValue("Key ce619484faf6427fa12b9da1543218b0", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
