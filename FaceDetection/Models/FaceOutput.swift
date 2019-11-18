//
//  FaceOutput.swift
//  FaceDetection
//
//  Created by Hesham Ali on 11/17/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import Foundation
struct FaceOutput: Codable {
    let id: String
    let status: Status
    let data: FaceOutputData
    
    enum CodingKeys: String, CodingKey {
        case id, status, data
    }
}
