//
//  LikedTests.swift
//  Catinder
//
//  Created by Ivan Solomatin on 27.11.2024.
//

import XCTest
@testable import Catinder

class LikedViewControllerTests: XCTestCase {
    
    func testViewControllerSetup() {
        let vcont = LikedViewController()
        _ = vcont.view
        
        XCTAssertEqual(vcont.title, "Liked Images")
        XCTAssertNotNil(vcont.tableView.superview)
        XCTAssertEqual(vcont.tableView.rowHeight, 420, "table view row height 420")
    }
    
    func testAddLikedImage() {
        let vcont = LikedViewController()
        _ = vcont.view
        let testImage = UIImage()

        vcont.addLikedImage(testImage)

        XCTAssertEqual(vcont.tableView.numberOfRows(inSection: 0), 1, "liked image in list")
        XCTAssertEqual(vcont.likedImages.count, 1, "likedImages array has one image")
    }
    
    func testCellConfiguration() {
        let vcont = LikedViewController()
        _ = vcont.view
        let testImage = UIImage()
        
        vcont.addLikedImage(testImage)
        let cell = vcont.tableView(vcont.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? LikedImageCell

        XCTAssertNotNil(cell, "Should be `LikedImageCell`")
        XCTAssertEqual(cell?.likedImageView.image, testImage)
    }
    
}
