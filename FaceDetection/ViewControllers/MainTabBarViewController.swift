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
        self.tabBarController?.selectedIndex = 1
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("changing")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if let tagsViewController = viewController as? TagsViewController {
            tagsViewController.faceSaveViewModel = faceSaveViewModel
        } else if let facesViewController = viewController as? FacesViewController {
            facesViewController.faceSaveViewModel = faceSaveViewModel
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
