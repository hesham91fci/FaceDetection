//
//  FaceDetectionTests.swift
//  FaceDetectionTests
//
//  Created by Hesham Ali on 11/17/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import XCTest
import RxSwift
@testable import FaceDetection

class FaceDetectionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    

    func testCountFaces() {
        let disposeBag = DisposeBag()
        let testImage = UIImage(named: "test")
        let mainImage:UIImageView = UIImageView(image: testImage)
        let numberOfFaces = 4
        let faceDetectorViewModel:FaceDetectorViewModel = FaceDetectorViewModel()
        let serviceExpectation = expectation(description: "Recognition waiting expectation")
        faceDetectorViewModel.observableFaces.bind(onNext: { (rectangles) in
            XCTAssertTrue(rectangles.count == numberOfFaces)
            serviceExpectation.fulfill()
            }).disposed(by: disposeBag)
        faceDetectorViewModel.recognizeFaces(image: mainImage)
        waitForExpectations(timeout: 5, handler: nil)

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
