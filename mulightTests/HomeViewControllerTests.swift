//
//  HomeViewControllerTests.swift
//  mulightTests
//
//  Created by jukui liu on 2019/7/29.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import XCTest
@testable import mulight

class HomeViewControllerTests: XCTestCase {
    var homeViewController: HomeViewController!

    override func setUp() {
        super.setUp()
        homeViewController = HomeViewController(MockHomeViewable())
    }
    
    override func tearDown() {
        homeViewController = nil
        super.tearDown()
    }
    
    func testGenerateTapButton() {
        let button = homeViewController.generateTapButton("this is title")
        XCTAssertEqual(button.titleLabel?.text, "this is title", "generate button is sucess")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
