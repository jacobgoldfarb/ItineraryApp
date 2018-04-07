//
//  DateTests.swift
//  FlyAppTests
//
//  Created by Jacob Goldfarb on 2018-03-10.
//  Copyright © 2018 JacobGoldfarb. All rights reserved.
//

import XCTest

@testable import FlyApp

class DateTests: XCTestCase {
    
    var date1 = Date()
    var date2 = Date()

    override func setUp() {
        super.setUp()
        
        date1.addTimeInterval(day_)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSubtraction() {
      
        let difference = date1 - date2
        
        XCTAssertEqual(difference, day_-1)
    }
    func testAddition(){
        
        date2 += day_
        
        XCTAssertEqual(date2, date1)
    }

    
}
