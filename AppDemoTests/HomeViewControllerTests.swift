//
//  HomeViewControllerTests.swift
//  AppDemoTests
//
//  Created by Daniel Bonates on 14/12/21.
//

import XCTest
@testable import AppDemo

class HomeViewControllerTests: XCTestCase {
    
    var sut: HomeViewController!

    override func setUpWithError() throws {
        sut = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewControllerID") as! HomeViewController)
        let _ = sut.view
    }

    override func tearDownWithError() throws {
    }
    
    
    func testHomeVC_tableViewShouldNotBeNil() {
        XCTAssertNotNil(sut.collectionView)
    }
    
    func testDataSource_ViewDidLoad_SetsCollectionViewDataSource() {
        XCTAssertNotNil(sut.collectionView?.dataSource)
        XCTAssertTrue(sut.collectionView?.dataSource is HomeViewControllerDataSource)
    }

    func testDelegate_ViewDidLoad_SetsCollectionViewDelegate() {
        XCTAssertNotNil(sut.collectionView?.delegate)
        XCTAssertTrue(sut.collectionView?.delegate is HomeViewControllerDelegate)
    }
}
