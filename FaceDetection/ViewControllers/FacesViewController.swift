//
//  ViewController.swift
//  FaceDetection
//
//  Created by Hesham Ali on 11/17/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreGraphics
class FacesViewController: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    let faceDetectorViewModel:FaceDetectorViewModel = FaceDetectorViewModel()
    let faceCropViewModel:FaceCropViewModel = FaceCropViewModel()
    let faceSaveViewModel:FaceSaveViewModel = FaceSaveViewModel()
    let disposeBag = DisposeBag()
    var faceRegions:[CGRect]?
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubscribers()
        //self.registerImagePickingDelegate()
        faceDetectorViewModel.recognizeFaces(image: self.mainImage)
    }
    
    func initSubscribers(){
        self.initFaceCropSubscriber()
        self.initFaceRegionsSubscriber()
    }
    func initFaceRegionsSubscriber(){
        self.faceDetectorViewModel.observableFaces.bind { (rectangles) in
            self.faceRegions = rectangles
            self.faceCropViewModel.loadImagesFromFaceRegions(faceRegions: rectangles, mainImage: self.mainImage)
            rectangles.forEach({ (rectangle) in
                let faceBoundary = UIView(frame: rectangle)
                faceBoundary.layer.borderColor = UIColor.blue.cgColor
                faceBoundary.layer.borderWidth = 1.5
                self.mainImage.addSubview(faceBoundary)
            })
            }.disposed(by: disposeBag)
    }
    
    func initFaceCropSubscriber(){
        self.faceCropViewModel.croppedObservableFaces.bind { (faceImages) in
            if !faceImages.isEmpty{
                for i in 0..<faceImages.count{
                    if let faceRegions = self.faceRegions{
                        let faceTextField = UITextField.init(frame: CGRect(x: faceRegions[i].minX, y: faceRegions[i].minY, width: 50, height: 30))
                        faceTextField.rx.controlEvent(UIControlEvents.editingDidEndOnExit).subscribe({ _ in
                            self.faceSaveViewModel.savePictureInfo(personFace: faceImages[i], personName: faceTextField.text!, mainImage: self.mainImage.image!, faceRegion: faceRegions[i])
                        }).disposed(by: self.disposeBag)
                        faceTextField.backgroundColor = .white
                        self.view.addSubview(faceTextField)
                    }
                }
            }
        }.disposed(by: disposeBag)
    }


}

