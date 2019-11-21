//
//  CameraViewController.swift
//  FaceDetection
//
//  Created by HHasaneen on 11/21/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    weak var mainTabBarController:MainTabBarViewController?
    var capturedImage:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if capturedImage == nil{
            self.registerImagePickingDelegate()
        }
    }
    
    func registerImagePickingDelegate(){
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.originalImage] as?
        UIImage {
            self.capturedImage = img
            self.dismiss(animated: true) {
                self.mainTabBarController?.changeToTagsViewController(image: img)
            }
        } else {
        print("error in taking image")
        }    }

}
