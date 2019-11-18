//
//  FaceDetection.swift
//  FaceDetection
//
//  Created by Hesham Ali on 11/17/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import Foundation


struct FaceDetection: Codable {
    let status: Status
    let outputs: [FaceOutput]
}

struct Status: Codable {
    let code: Int
    let statusDescription: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case statusDescription = "description"
    }
}
