//
//  FlyAppTests.swift
//  FlyAppTests
//
//  Created by Jacob Goldfarb on 2018-03-03.
//  Copyright © 2018 JacobGoldfarb. All rights reserved.
//

import XCTest
@testable import FlyApp

class TimeTableTests: XCTestCase {
    
    var today:Timetable!
    var yesterday:Timetable!
    
    var venueCall = [VenueCall]()
    var sortedInfo = [Paramater]()
    var fourSquareParams = [FoursquareAPIArguments()]
    
    override func setUp() {
        super.setUp()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let dateTime = formatter.date(from: "2018/03/03 00:00")

        today = Timetable(inDate: dateTime!, tripLength: 5, offsetBy: 1)
        yesterday = Timetable(inDate: dateTime!, tripLength: 5, offsetBy: 0)
        today.yesterday = yesterday
        yesterday.bedtime.startTime = yesterday.instanceDate.addingTimeInterval(hour_*26)
        
        
        makeFourSquareParams()
        makeSortedInfo()
        
        for param in fourSquareParams{
            let aVenueCall = VenueCall.init(params: param)
            venueCall.append(aVenueCall)
        }
    }
    
    override func tearDown() {
        
        today = nil
        yesterday = nil
        super.tearDown()
    }
    func makeFourSquareParams(){
        
        let fourSquareParams1 = FoursquareAPIArguments.init(param: "nightlifeLevel", value: 3, tripLength: 4, budget: 2, destination: "Toronto")
        let fourSquareParams2 = FoursquareAPIArguments.init(param: "cultureLevel", value: 3, tripLength: 4, budget: 2, destination: "Toronto")
        let fourSquareParams3 = FoursquareAPIArguments.init(param: "parksLevel", value: 3, tripLength: 4, budget: 2, destination: "Toronto")
        let fourSquareParams4 = FoursquareAPIArguments.init(param: "historyLevel", value: 3, tripLength: 4, budget: 2, destination: "Toronto")
        let fourSquareParams5 = FoursquareAPIArguments.init(param: "shoppingLevel", value: 3, tripLength: 4, budget: 2, destination: "Toronto")
        
        fourSquareParams.append(fourSquareParams1)
        fourSquareParams.append(fourSquareParams2)
        fourSquareParams.append(fourSquareParams3)
        fourSquareParams.append(fourSquareParams4)
        fourSquareParams.append(fourSquareParams5)
    }
    func makeSortedInfo(){
        
        let param1:Paramater = (param: "nightlifeLevel", value: 3)
        sortedInfo.append(param1)
        
        let param2:Paramater = (param: "cultureLevel", value: 2)
        sortedInfo.append(param2)
        
        let param3:Paramater = (param: "parksLevel", value: 2)
        sortedInfo.append(param3)
        
        let param4:Paramater = (param: "historyLevel", value: 2)
        sortedInfo.append(param4)
        
        let param5:Paramater = (param: "shoppingLevel", value: 2)
        sortedInfo.append(param5)
    }
    func testWakeup() {
        let targetWakeup = today.instanceDate.addingTimeInterval(hour_*15)
        let wakeUp = today.getWakeup(withActivity: 5)

      //  XCTAssertEqual(wakeUp.startTime, targetWakeup)
    }
    
    func testShouldAdd() {
        
        let shouldAdd1 = today.shouldAdd(withRatio: 0.5, andParameterValue: 5, desperateFactor: 1)
        XCTAssertTrue(shouldAdd1)
        
        let shouldAdd2 = today.shouldAdd(withRatio: 0.4, andParameterValue: 2, desperateFactor: 1)
        XCTAssertFalse(shouldAdd2)
        
        let shouldAdd3 = today.shouldAdd(withRatio: 0.1, andParameterValue: 1, desperateFactor: 1)
        XCTAssertFalse(shouldAdd3)
    }
    func testPopulateVenues(){
        
        today.populateVenues(forAll: venueCall, with: sortedInfo)
        today.printAllVenues()
        
    }
    
}
