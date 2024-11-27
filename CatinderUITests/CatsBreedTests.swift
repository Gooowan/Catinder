//
//  Task1TestsLaunchTests.swift
//  Task1Tests
//
//  Created by Ivan Solomatin on 27.11.2024.
//

import XCTest
@testable import Catinder
import Combine

class CatBreedsViewControllerTests: XCTestCase {
    
    func testViewControllerSetup() {
        let vcont = CatBreedsViewController()
        _ = vcont.view
        
        XCTAssertEqual(vcont.title, "Cat Breeds")
        XCTAssertEqual(vcont.tableView.rowHeight, 120, "The table view row height 120")
        XCTAssertNotNil(vcont.tableView.superview)
    }
    
    func testTableViewHasDataSourceAndDelegate() {
        let vcont = CatBreedsViewController()
        _ = vcont.view
        
        XCTAssertNotNil(vcont.tableView.dataSource, "The table view data source not nil")
        XCTAssertNotNil(vcont.tableView.delegate, "The table view delegate not nil")
    }

    func testTableViewReloadsAfterFetchingBreeds() {
        let vcont = CatBreedsViewController()
        let mockService = MockCatAPIService()
        vcont.catAPIService = mockService
        let expectation = XCTestExpectation(description: "Table view reloads after fetching breeds")
        
        _ = vcont.view
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(vcont.tableView.numberOfRows(inSection: 0), 1, "The table view with one row after loading")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}

// Mock for testing
class MockCatAPIService: CatAPIService {
    override func fetchCatBreeds() -> AnyPublisher<[Breed], Error> {
        return Just([
            Breed(id: "1", name: "Breed", temperament: "Temperament", origin: "Ukraine")
        ])
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
}
