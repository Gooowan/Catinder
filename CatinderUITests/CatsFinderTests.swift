//
//  CatsFinderTests.swift
//  Catinder
//
//  Created by Ivan Solomatin on 27.11.2024.
//

import XCTest
@testable import Catinder

class CatFinderViewControllerTests: XCTestCase {
    
    func testViewControllerSetup() {
        let vcont = CatFinderViewController()
        _ = vcont.view
        
        XCTAssertEqual(vcont.title, "Rate Cats")
        XCTAssertNotNil(vcont.spinnerView.superview)
        XCTAssertNotNil(vcont.catImageView.superview)
    }
    
    func testSwipeGesturesAddedToCatImageView() {
        let vcont = CatFinderViewController()
        _ = vcont.view
        
        let gestures = vcont.catImageView.gestureRecognizers?.compactMap { $0 as? UISwipeGestureRecognizer }
        XCTAssertEqual(gestures?.count, 2, "Two swipe gesture")
    }
    
    func testSpinnerVisibilityDuringImageLoad() {
        let vcont = CatFinderViewController()
        let mockService = MockCatAPIService()
        vcont.catAPIService = mockService
        _ = vcont.view
        
        vcont.loadNewCatImage()
        XCTAssertFalse(vcont.spinnerView.isHidden, "Spinner visible while loading image")
    }
}
