//
//  ImageTableViewCellTests.swift
//  mulightTests
//
//  Created by jukui liu on 7/30/19.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import XCTest
@testable import mulight

// ToDo - rewrite with QUick/Nimble
class ImageTableViewCellTests: XCTestCase {
    var imageTableViewCell: ImageTableViewCell!
    
    override func setUp() {
        super.setUp()
        imageTableViewCell = ImageTableViewCell.init(style: .subtitle, reuseIdentifier: "ImageTableViewCell")
    }
    
    override func tearDown() {
        imageTableViewCell = nil
        super.tearDown()
    }
        
    func testUpdate() {
        imageTableViewCell.update(ImageModel.init(name: "hi", filePath: "path", createTime: 123))
        XCTAssertEqual(imageTableViewCell.textLabel?.text, "hi", "index image is sucess")
    }
    
    // ToDo - add test and refactor
}
