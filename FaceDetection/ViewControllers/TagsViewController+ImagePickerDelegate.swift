//
//  FacesViewController+ImagePickerDelegate.swift
//  FaceDetection
//
//  Created by Hesham Ali on 11/20/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import Foundation
import UIKit
extension TagsViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func registerImagePickingDelegate(){
        var imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("helloooooooo")
    }
    
}
