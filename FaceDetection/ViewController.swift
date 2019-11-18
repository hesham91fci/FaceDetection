//
//  ViewController.swift
//  FaceDetection
//
//  Created by Hesham Ali on 11/17/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let testImage = UIImage(named: "test")
        FaceDetectorService.getFaces(image: testImage!)
    }


}

