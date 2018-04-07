//
//  VenueCallTests.swift
//  FlyAppTests
//
//  Created by Jacob Goldfarb on 2018-03-04.
//  Copyright © 2018 JacobGoldfarb. All rights reserved.
//

import XCTest
@testable import FlyApp


class VenueCallTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInit() {
        let foursquareParams = FoursquareAPIArguments(param: "Night Life", value: 4, tripLength: 2, budget: 3, destination: "Tahiti")
        let venueCall1 = VenueCall(params: foursquareParams)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
