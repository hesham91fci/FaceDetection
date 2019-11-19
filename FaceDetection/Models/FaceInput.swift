//
//  FaceInput.swift
//  FaceDetection
//
//  Created by Hesham Ali on 11/18/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import Foundation

struct FaceInput: Codable {
    let inputs: [Input]
}

struct Input: Codable {
    let data: DataClass
}

struct DataClass: Codable {
    let image: Image
}

struct Image: Codable {
    let base64: String
}
