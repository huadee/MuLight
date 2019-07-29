//
//  ListViewModelTests.swift
//  mulightTests
//
//  Created by jukui liu on 7/30/19.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import XCTest
@testable import mulight

// ToDo - rewrite with QUick/Nimble
class ListViewModelTests: XCTestCase {
    var listViewModel: ListViewModel!
    var mockImageServiceable: MockImageServiceable!
    
    override func setUp() {
        super.setUp()
        mockImageServiceable = MockImageServiceable()
        listViewModel = ListViewModel(mockImageServiceable)
    }
    
    override func tearDown() {
        listViewModel = nil
        super.tearDown()
    }
    
    func testRefreshData() {
        let _ = listViewModel.refreshData()
        XCTAssertEqual(mockImageServiceable.fetchImageListCalled, true, "fetch image is sucess")
    }
    
    func testImage() {
        let _ = listViewModel.refreshData()
        let model = listViewModel.image(0)
        XCTAssertEqual(model.name, "name", "index image is sucess")
    }
    // ToDo - add test and refactor
}
