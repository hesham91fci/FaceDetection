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
struct FaceDetectorService {
    static func getFaces(image: UIImage) -> Observable<FaceDetection> {
        let faceDetectionRequest = try! APIRouter.detectFaces(image: image).asURLRequest()
        return request(faceDetectionRequest)
    }
    
    private static func request<T:Codable>(_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            APIManager.shared().request(urlConvertible).responseJSON { (response: DataResponse) in
                switch response.result {
                case .success:
                    let decoder = JSONDecoder()
                    do{
                        let t = try decoder.decode(T.self, from: response.data!)
                        observer.onNext(t)
                    }
                    catch{
                        observer.onError(ApiError.internalServerError)
                    }
                case .failure(let error):
                    handleError(response: response,error: error,observer: observer)
                }
            }
            return Disposables.create()
        }
    }
    
    private static func handleError<T:Codable>(response:DataResponse<Any>,error:Error,observer:AnyObserver<T>){
        switch response.response?.statusCode {
        case 403:
            observer.onError(ApiError.forbidden)
        case 404:
            observer.onError(ApiError.notFound)
        case 409:
            observer.onError(ApiError.conflict)
        case 500:
            observer.onError(ApiError.internalServerError)
        default:
            observer.onError(error)
        }
    }

}
