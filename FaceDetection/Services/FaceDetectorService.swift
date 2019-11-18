//
//  DetectFacesService.swift
//  FaceDetection
//
//  Created by Hesham Ali on 11/17/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RxSwift
class FaceDetectorService {
    static func getFaces(image: UIImage) /*-> Observable<FaceDetection>*/ {
        let faceDetectionRequest = try! APIRouter.detectFaces(image: image).asURLRequest()
        request(faceDetectionRequest)
    }
    
    private static func request(_ urlConvertible: URLRequestConvertible) /*-> Observable<T>*/ {
        
        let task = URLSession.shared.uploadTask(with: urlConvertible.urlRequest!, from: urlConvertible.urlRequest!.httpBody!) {(data
            , response, error) in
            if let error = error {
                print ("error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                    return
            }
            
            if !(200...209).contains(response.statusCode){
                switch response.statusCode {
                case 403:
                    print("hi")
                //  observer.onError(ApiError.forbidden)
                case 404:
                    print("hi")
                //  observer.onError(ApiError.notFound)
                case 409:
                    print("hi")
                //  observer.onError(ApiError.conflict)
                case 500:
                    print("hi")
                //  observer.onError(ApiError.internalServerError)
                default:
                    print("hi")
                    //  observer.onError(error)
                }
            }
            
            if let data = data{
            
                let decoder = JSONDecoder()
                do{
                    let faces = try decoder.decode(FaceDetection.self, from: data)
                    print("succeeded")
                    //observer.onNext(t)
                }
                catch{
                    print("couldn't parse")
                    //observer.onError(ApiError.internalServerError)
                }
            }
        }
        
        task.resume()
//        //return Observable<T>.create { observer in
//            APIManager.shared().upload(urlConvertible.urlRequest!.httpBody!, to: urlConvertible.urlRequest!.url!.description).responseJSON { (response: DataResponse) in
//
//                switch response.result {
//                case .success(let value):
//                    let decoder = JSONDecoder()
//                    do{
//                        let faces = try decoder.decode(FaceDetection.self, from: response.data!)
//                        print("succeeded")
//                        //observer.onNext(t)
//                    }
//                    catch{
//                        //observer.onError(ApiError.internalServerError)
//                    }
//                    //observer.onCompleted()
//                case .failure(let error):
//                    switch response.response?.statusCode {
//                    case 403:
//                        print("hi")
//                      //  observer.onError(ApiError.forbidden)
//                    case 404:
//                        print("hi")
//                      //  observer.onError(ApiError.notFound)
//                    case 409:
//                        print("hi")
//                      //  observer.onError(ApiError.conflict)
//                    case 500:
//                        print("hi")
//                      //  observer.onError(ApiError.internalServerError)
//                    default:
//                        print("hi")
//                      //  observer.onError(error)
//                    }
//                }
//            }
//            //return Disposables.create()
//        //}
    }

}
