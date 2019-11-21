//
//  FaceDetectorViewModel.swift
//  FaceDetection
//
//  Created by Hesham Ali on 11/18/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import Foundation
import RxSwift
struct FaceDetectorViewModel {
    private let facesSubject:BehaviorSubject<[CGRect]> = BehaviorSubject(value: [])
    private let errorSubject = BehaviorSubject<String>(value: "")
    private let isLoadingSubject = BehaviorSubject<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    var error: Observable<String> {
        return self.errorSubject.asObservable()
    }
    var observableFaces: Observable<[CGRect]>{
        return self.facesSubject.asObservable()
    }
    var isLoading: Observable<Bool> {
        return self.isLoadingSubject.asObservable()
    }

    func recognizeFaces(image:UIImageView){
        isLoadingSubject.onNext(true)
        if let uiImage = image.image{
            FaceDetectorService.getFaces(image: uiImage).subscribe(onNext: { [self] faces in
                self.isLoadingSubject.onNext(false)
                self.getAllFaces(forImage: image, faceResponse: faces)
            }, onError: { (error) in
                self.isLoadingSubject.onNext(false)
                self.errorSubject.onNext("Problem detecting faces")
            }
            ).disposed(by: disposeBag)
        }
    }
    
    private func getAllFaces(forImage image:UIImageView, faceResponse:FaceDetection){
        var faceBoundaries:[CGRect] = [CGRect]()
        let imageWidth = image.bounds.width
        let imageHeight = image.bounds.height
        if let output = faceResponse.outputs.first{
            output.data.regions.forEach { (region) in
                let boundingBox = region.regionInfo.boundingBox
                let rectangle = CGRect(x: imageWidth * CGFloat(boundingBox.leftCol),
                                       y: imageHeight * CGFloat(boundingBox.topRow),
                                       width: (CGFloat(boundingBox.rightCol) * imageWidth) - (CGFloat(boundingBox.leftCol) * imageWidth),
                                       height: (CGFloat(boundingBox.bottomRow) * imageHeight) - (CGFloat(boundingBox.topRow) * imageHeight))
                faceBoundaries.append(rectangle)
            }
        }
        self.facesSubject.onNext(faceBoundaries)
    }
    
    
}
