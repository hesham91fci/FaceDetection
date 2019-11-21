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
    }
    
    func registerDelegateForCameraViewController(){
        self.viewControllers?.forEach({ (controller) in
            if let cameraViewController = controller as? CameraViewController{
                cameraViewController.mainTabBarController = self
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
                tagsViewController.faceSaveViewModel = faceSaveViewModel
            }
        })
    }

}
