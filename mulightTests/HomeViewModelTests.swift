//
//  HomeViewModelTests.swift
//  mulightTests
//
//  Created by jukui liu on 7/30/19.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import XCTest
@testable import mulight

// ToDo - rewrite with QUick/Nimble
class HomeViewModelTests: XCTestCase {
    var homeViewModel: HomeViewModel!
    var mockImageServiceable: MockImageServiceable!
    
    override func setUp() {
        super.setUp()
        mockImageServiceable = MockImageServiceable()
        homeViewModel = HomeViewModel(mockImageServiceable)
    }
    
    override func tearDown() {
        homeViewModel = nil
        super.tearDown()
    }
    
    func testSaveImage() {
        let _ = homeViewModel.saveImage(Data(), "name")
        XCTAssertEqual(mockImageServiceable.saveCalled, true, "save image is sucess")
    }
    // ToDo - add test and refactor
}

