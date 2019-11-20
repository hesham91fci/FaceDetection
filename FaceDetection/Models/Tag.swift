//
//  Picture.swift
//  FaceDetection
//
//  Created by Hesham Ali on 11/19/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import Foundation
import UIKit
struct Tag:Codable {
    var personFace:UIImage?
    var personName:String
    var faceRegion:CGRect
    var includingPicture:UIImage?
    
    init(personFace:UIImage,personName:String,faceRegion:CGRect,includingPicture:UIImage) {
        self.personFace = personFace
        self.personName = personName
        self.faceRegion = faceRegion
        self.includingPicture = includingPicture
    }
    
    enum CodingKeys: String, CodingKey {
        case personFace
        case personName
        case faceRegion
        case includingPicture
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        personName = try container.decode(String.self, forKey: .personName)
        faceRegion = try container.decode(CGRect.self, forKey: .faceRegion)
        let pictureData = try container.decode(Data.self, forKey: .includingPicture)
        let data = try container.decode(Data.self, forKey: .personFace)
        if let image = UIImage(data: data){
            personFace = image
        }
        if let image = UIImage(data: pictureData){
            includingPicture = image
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(personName, forKey: .personName)
        if let data = personFace?.pngData() {
            try container.encode(data, forKey: .personFace)
        }
        try container.encode(faceRegion, forKey: .faceRegion)
        if let data = includingPicture?.pngData() {
            try container.encode(data, forKey: .includingPicture)
        }
    }

}
