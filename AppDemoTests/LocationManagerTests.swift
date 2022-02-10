//
//  LocationManagerTests.swift
//  AppDemoTests
//
//  Created by Daniel Bonates on 14/12/21.
//

import XCTest
@testable import AppDemo

class LocationManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLocationManager_LocationsArrayIsNotNil() {
        let locationsManager = LocationsManager()
        XCTAssertNotNil(locationsManager.locations)
    }
    
    
}
