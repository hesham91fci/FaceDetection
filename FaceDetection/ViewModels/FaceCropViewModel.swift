//
//  FaceCropViewModel.swift
//  FaceDetection
//
//  Created by Hesham Ali on 11/19/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
struct FaceCropViewModel{
    private let croppedFacesSubject:BehaviorSubject<[UIImage]> = BehaviorSubject(value: [])
    var croppedObservableFaces: Observable<[UIImage]>{
        return self.croppedFacesSubject.asObservable()
    }
    func loadImagesFromFaceRegions(faceRegions:[CGRect],mainImage:UIImageView){
        
            var newFacesImages:[UIImage] = []
            faceRegions.forEach { (rectangle) in
                let newSize:CGSize =  CGSize(width: mainImage.frame.width,height: mainImage.frame.height)
                let rect = CGRect(x: 0, y: 0,width: newSize.width,height: newSize.height)
                UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
                mainImage.image!.draw(in: rect)
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                let croppedFace = UIImage(cgImage: newImage!.cgImage!.cropping(to: rectangle)!)
                newFacesImages.append(croppedFace)
            }
            self.croppedFacesSubject.onNext(newFacesImages)
    }
}
