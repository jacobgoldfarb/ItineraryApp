//
//  TripTests.swift
//  FlyAppTests
//
//  Created by Jacob Goldfarb on 2018-03-04.
//  Copyright © 2018 JacobGoldfarb. All rights reserved.
//

import XCTest
@testable import FlyApp

class TripTests: XCTestCase {
    
    var trip:Trip!
    
    override func setUp() {
        super.setUp()
        trip = Trip()
        //trip.createTrip()
    }
    
    override func tearDown() {
        
        trip = nil
        super.tearDown()
    }
    
    func testGetTripLength() {
        
        let date1 = Date()
        let date2 = date1.addingTimeInterval(day_*2.5)
        
        let tripLength = trip.getTripLength(from: date1, to: date2)
        
        XCTAssertEqual(tripLength, 2)
    }

    func testFetchVenues(){
        
    }
    func testCalculateJourneys(){
        
        let journeys1 = trip.calculateJourneys(usingActivityLevel: 2)
        let journeys2 = trip.calculateJourneys(usingActivityLevel: 3)
        let journeys3 = trip.calculateJourneys(usingActivityLevel: 4)
        let journeys4 = trip.calculateJourneys(usingActivityLevel: 1)

        XCTAssertEqual(journeys1, 3)
        XCTAssertEqual(journeys2, 4)
        XCTAssertEqual(journeys3, 5)
        XCTAssertEqual(journeys4, 2)
    }

    
}
