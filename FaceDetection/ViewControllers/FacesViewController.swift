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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.faceSaveViewModel?.observableTags
            .bind(to: facesTableView
                .rx
                .items(cellIdentifier: "FacesTableViewCell",
                       cellType: FacesTableViewCell.self)) { row, tag, cell in
                        cell.configureFaceCell(tag: tag)
            }
            .disposed(by: disposeBag)
        self.faceSaveViewModel?.observableTags.bind(onNext: { (tags) in
            print("emitted")
        }).disposed(by: disposeBag)
        self.faceSaveViewModel?.getPicturesFromUserDefaults()
        
        
    }
}
