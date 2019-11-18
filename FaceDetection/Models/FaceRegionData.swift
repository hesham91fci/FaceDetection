//
//  FaceRegionData.swift
//  FaceDetection
//
//  Created by Hesham Ali on 11/17/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import Foundation
struct Region: Codable {
    let regionInfo: RegionInfo
    
    enum CodingKeys: String, CodingKey {
        case regionInfo = "region_info"
    }
}

struct RegionInfo: Codable {
    let boundingBox: BoundingBox
    
    enum CodingKeys: String, CodingKey {
        case boundingBox = "bounding_box"
    }
}

struct BoundingBox: Codable {
    let topRow, leftCol, bottomRow, rightCol: Double
    
    enum CodingKeys: String, CodingKey {
        case topRow = "top_row"
        case leftCol = "left_col"
        case bottomRow = "bottom_row"
        case rightCol = "right_col"
    }
}
