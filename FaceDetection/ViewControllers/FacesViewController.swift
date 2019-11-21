//
//  FacesViewController.swift
//  FaceDetection
//
//  Created by Hesham Ali on 11/20/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class FacesViewController: UIViewController {

    let disposeBag = DisposeBag()
    @IBOutlet weak var facesTableView: UITableView!
    var faceSaveViewModel:FaceSaveViewModel?
    weak var mainTabBarController:MainTabBarViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subscribeOnFaces()
        self.subcribeForFaceTap()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func subcribeForFaceTap(){
        self.facesTableView.rx.itemSelected
        .subscribe(onNext: { [weak self] indexPath in
            self?.subscribeForPictureTags()
            self?.faceSaveViewModel?.getPictureForFace(atIndex: indexPath.row)
        }).disposed(by: disposeBag)
    }
    
    func subscribeForPictureTags(){
        self.faceSaveViewModel?.observablePictureTags.bind(onNext: { (tags) in
            if let tag = tags.first,let includingPicture = tag.includingPicture{
                self.mainTabBarController?.changeToTagsViewController(image: includingPicture)
            }
            
            }).disposed(by: disposeBag)
    }
    
    func subscribeOnFaces(){
        self.faceSaveViewModel?.observableAllTags
            .bind(to: facesTableView
                .rx
                .items(cellIdentifier: "FacesTableViewCell",
                       cellType: FacesTableViewCell.self)) { row, tag, cell in
                        cell.configureFaceCell(tag: tag)
            }
            .disposed(by: disposeBag)
    }
}
