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
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubscribers()
        faceDetectorViewModel.recognizeFaces(image: self.mainImage)
    }
    
    func initSubscribers(){
        self.faceDetectorViewModel.observableFaces.bind { (rectangles) in
            rectangles.forEach({ (rectangle) in
                let faceBoundary = UIView(frame: rectangle)
                faceBoundary.layer.borderColor = UIColor.blue.cgColor
                faceBoundary.layer.borderWidth = 1.5
                self.mainImage.addSubview(faceBoundary)
            })
        }.disposed(by: disposeBag)
        
    }


}

