//
//  mulightUITests.swift
//  mulightUITests
//
//  Created by jukui liu on 2019/7/27.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import XCTest
@testable import mulight

class mulightUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testHomeView() {
        app.launch()
        let isDispalyHomeView = app.otherElements["homeView"].exists
        XCTAssertTrue(isDispalyHomeView, "home view success")
        let isDispalyTakePhotoButton = app.buttons["takePhotoButton"].exists
        XCTAssertTrue(isDispalyTakePhotoButton, "take photo button success")
        let isDispalyPhotoListButton = app.buttons["photoListButton"].exists
        XCTAssertTrue(isDispalyPhotoListButton, "photo list button success")
        
        app.buttons["photoListButton"].tap()
        let isDispalyListView = app.otherElements["listView"].exists
        XCTAssertTrue(isDispalyListView, "list view success")
    }
    
    func testListView() {
        // ToDo - use QUick/Nimble to test the cell selected
    }
    
    func testDetailView() {
        // ToDo - use QUick/Nimble to test the cell selected
    }
}
