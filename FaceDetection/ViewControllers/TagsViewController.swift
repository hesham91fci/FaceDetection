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
class TagsViewController: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    let faceDetectorViewModel:FaceDetectorViewModel = FaceDetectorViewModel()
    let faceCropViewModel:FaceCropViewModel = FaceCropViewModel()
    var faceSaveViewModel:FaceSaveViewModel = FaceSaveViewModel()
    let disposeBag = DisposeBag()
    var faceRegions:[CGRect]?
    var faceBoundaries: [UIView]?
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubscribers()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        faceDetectorViewModel.recognizeFaces(image: self.mainImage)
    }
    
    func initSubscribers(){
        self.initFaceCropSubscriber()
        self.initFaceRegionsSubscriber()
    }
    func initFaceRegionsSubscriber(){
        self.faceDetectorViewModel.observableFaces.bind { (rectangles) in
            self.drawFaces(rectangles: rectangles)
            }.disposed(by: disposeBag)
    }
    
    func initTagsSubscriber(){
        self.faceSaveViewModel.observablePictureTags.bind { (tags) in
            tags.forEach { (tag) in
                self.drawFaces(rectangles: [tag.faceRegion])
            }
        }.disposed(by: disposeBag)
    }
    
    func drawFaces(rectangles:[CGRect]){
        self.faceRegions = rectangles
        self.faceCropViewModel.loadImagesFromFaceRegions(faceRegions: rectangles, mainImage: self.mainImage)
        rectangles.forEach({ (rectangle) in
            let faceBoundary = UIView(frame: rectangle)
            self.faceBoundaries?.append(faceBoundary)
            faceBoundary.layer.borderColor = UIColor.blue.cgColor
            faceBoundary.layer.borderWidth = 1.5
            self.mainImage.addSubview(faceBoundary)
        })
    }
    
    func initFaceCropSubscriber(){
        self.faceCropViewModel.croppedObservableFaces.bind { (faceImages) in
            if !faceImages.isEmpty{
                for i in 0..<faceImages.count{
                    if let faceRegions = self.faceRegions{
                        let faceTextField = UITextField.init(frame: CGRect(x: faceRegions[i].minX, y: faceRegions[i].minY, width: 50, height: 30))
                        faceTextField.layer.borderColor = UIColor.black.cgColor
                        faceTextField.layer.borderWidth = 1.0
                        faceTextField.text = self.faceSaveViewModel.getPersonNameFromImage(faceImage: faceImages[i])
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
    
    override func viewWillDisappear(_ animated: Bool) {
        faceBoundaries?.forEach({ (faceBoundary) in
            faceBoundary.removeFromSuperview()
        })
        self.mainImage.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
        self.view.subviews.forEach { (subview) in
            if subview is UITextField{
                subview.removeFromSuperview()
            }
        }
        faceBoundaries?.removeAll()
        faceRegions?.removeAll()
    }


}

