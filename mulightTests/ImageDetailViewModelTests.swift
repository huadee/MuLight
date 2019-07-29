//
//  ImageDetailViewModelTests.swift
//  mulightTests
//
//  Created by jukui liu on 7/30/19.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import XCTest
@testable import mulight

// ToDo - rewrite with QUick/Nimble
class ImageDetailViewModelTests: XCTestCase {
    var imageDetailViewModel: ImageDetailViewModel!
    var mockImageServiceable: MockImageServiceable!
    var mockImagePath: String!
    
    override func setUp() {
        super.setUp()
        mockImageServiceable = MockImageServiceable()
        mockImagePath = "/path"
        imageDetailViewModel = ImageDetailViewModel(mockImageServiceable, imagePath: mockImagePath)
    }
    
    override func tearDown() {
        imageDetailViewModel = nil
        super.tearDown()
    }
    
    func testImage() {
        let _ = imageDetailViewModel.image()
        XCTAssertEqual(mockImageServiceable.loadImageCalled, true, "load image is sucess")
    }
    // ToDo - add test and refactor
}
