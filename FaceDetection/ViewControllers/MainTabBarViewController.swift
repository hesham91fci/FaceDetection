//
//  MainTabBarViewController.swift
//  FaceDetection
//
//  Created by Hesham Ali on 11/21/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    
    var faceSaveViewModel:FaceSaveViewModel = FaceSaveViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registerDelegateForCameraViewController()
        registerDelegateForFacesViewController()
        if !faceSaveViewModel.getPicturesFromUserDefaults().tagsDictionary.isEmpty && self.getCameraViewController()?.capturedImage == nil{
            self.changeToFacesViewController()
        }
        else{
            self.getCameraViewController()?.capturedImage = nil
        }
    }
    
    func registerDelegateForCameraViewController(){
        self.viewControllers?.forEach({ (controller) in
            if let cameraViewController = controller as? CameraViewController{
                cameraViewController.mainTabBarController = self
            }
        })
    }
    
    func registerDelegateForFacesViewController(){
        self.viewControllers?.forEach({ (controller) in
            if let facesViewController = controller as? FacesViewController{
                facesViewController.mainTabBarController = self
                facesViewController.faceSaveViewModel = self.faceSaveViewModel
            }
        })
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if let tagsViewController = viewController as? TagsViewController {
            tagsViewController.faceSaveViewModel = faceSaveViewModel
        } else if let facesViewController = viewController as? FacesViewController {
            facesViewController.faceSaveViewModel = faceSaveViewModel
        }
    }
    
    func changeToTagsViewController(image:UIImage){
        self.selectedIndex = 1
        self.viewControllers?.forEach({ (controller) in
            if let tagsViewController = controller as? TagsViewController{
                tagsViewController.mainImage.image = image
                if let cameraVC = self.getCameraViewController(){
                    if cameraVC.capturedImage != nil{
                        tagsViewController.mainImage.image = UIImage(cgImage: (FaceCropViewModel().resizeImageToImageView(mainImage: tagsViewController.mainImage)?.cgImage)!)
                        cameraVC.dismiss(animated: true, completion: nil)
                    }
                }

                tagsViewController.faceSaveViewModel = faceSaveViewModel
            }
        })
    }
    
    func changeToFacesViewController(){
        self.selectedIndex = 2
        self.viewControllers?.forEach({ (controller) in
            if let cameraViewController = controller as? CameraViewController{
                cameraViewController.dismiss(animated: true) {
                    cameraViewController.capturedImage = nil
                }
            }
            
        })
    }
    
    private func getCameraViewController() -> CameraViewController?{
        return self.viewControllers?.first(where: {$0 is CameraViewController}) as? CameraViewController
    }

}
