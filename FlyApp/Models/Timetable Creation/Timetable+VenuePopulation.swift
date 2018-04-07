//
//  Timetable+VenuePopulation.swift
//  FlyApp
//
//  Created by Jacob Goldfarb on 2018-03-20.
//  Copyright © 2018 JacobGoldfarb. All rights reserved.
//

import Foundation
import CoreLocation

///Method's used to determine which venues should be placed in this day of the trip.
extension Timetable{
    ///Picks which venues should be used for this timetable.
    func populateVenues(forAll venuesList: [VenueCall], with params:[Paramater]){
        var loop = 0
        print("All params: \(params)")
        while(allVenues.count < journeysPerDay){
            loop += 1
            print("ON LOOP \(loop)")
            for i in 0..<params.count-1{
                print("Parameters count: \(params.count)")
                /*  guard isParamValueUnique(value: paramaters[i].value, inArray: paramaters) else{
                 if(tiebreak()){}
                 continue
                 }*/
                print("------adding venues for parameter \(params[i].name)------")
                print("Total venues in list: \(venuesList[i].venues.count), venue list usageCount: \(venuesList[i].usageCount)")

                guard(venuesList[i].venues.count > venuesList[i].usageCount) else{
                    print("Venue list is not big enough")
                    continue
                }
                let usageRatio = Double(venuesList[i].usageCount)/Double(day)
                print("Useage ratio \(usageRatio)")
                if(shouldAdd(withRatio: usageRatio, andParameterValue: params[i].value, desperateFactor: loop)){
                    print("Should add \(params[i].name) to list")
                    venuesList[i].usageCount += 1
                    addVenue(from: venuesList[i])
                }
                print("Journeys per day: \(journeysPerDay)")
                guard allVenues.count < journeysPerDay else{
                    print("All venues is greater than journey per day, breaking.")
                    break
                }
            }
            print("All venues count is \(allVenues.count)")
            if(loop >= 30){ print("Tried looping too many times, event population failed."); break }
        }
        print("Continue population function")
        let venueTimes = getVenueEvents(forVenues: allVenues)
        eventTimes += venueTimes
        eventTimes = sortEventsByTime(allEvents: eventTimes)
        print("Event times in pop function: \(eventTimes)")
    }

    func isParamValueUnique(value:Int, inArray parameterArray: [Paramater]) -> Bool{
        
        var existingValueCount:Int = 0
        for eachElement in parameterArray{
            
            existingValueCount += eachElement.value == value ? 1 : 0
            if(existingValueCount > 1){
                return false
            }
        }
        return true
    }
    func addVenue(from venueList:VenueCall){
        
        let i = venueList.usageCount - 1
        
        print("Attempting to add venue \(i) of \(venueList.parameter.name)")
        
        guard i < venueList.totalVenues else{
            print("Usage count \(i) is greater than number of available venues (\(venueList.totalVenues)) for paramater \(venueList.parameter.name)")
            return
        }
        venueList.venues[i].used = true
        allVenues.append(venueList.venues[i])
    }
    
    func shouldAdd(withRatio usageRatio: Double, andParameterValue value:Int, desperateFactor loop: Int) -> Bool{
        
        let addCase = determineAddCase(forValue: Double(value))// Double(value)/10.0
        print("Add case is \(addCase*Double(loop)), usage ratio is \(usageRatio)")
        
        return usageRatio <= addCase*Double(loop) ? true : false
    }
    func determineAddCase(forValue value: Double) -> Double{
        
        switch value {
        case 1:
            return 0
        case 2:
            return 0.25
        case 3:
            return 0.4
        case 4:
            return 0.5
        case 5:
            return 0.7
        default:
            return 0
        }
    }
    
    func tiebreak() -> Bool {
        return arc4random_uniform(2) == 0
    }
   // func getEuclidian(long1: Double, lat1: Double, long2: Double, lat2: Double) -> Double{
    func getEuclidianDistance(between venue1: SingularVenue, and venue2: SingularVenue) -> Double{
        
        let long1 = venue1.address.longitude
        let long2 = venue2.address.longitude
        
        let lat1 = venue1.address.latitude
        let lat2 = venue2.address.latitude
        
        let coord1 = CLLocation(latitude: lat1, longitude: long1)
        let coord2 = CLLocation(latitude: lat2, longitude: long2)

        return coord1.distance(from: coord2)
    }
    func getFirstVenue(forVenues venues: [SingularVenue]) -> SingularVenue{
        
        let maxElement = UInt32(venues.count)
        var position = Int(arc4random_uniform(maxElement))
        
        while(venues[position].parameter.name == "nightlifeLevel"){
            position = Int(arc4random_uniform(maxElement))
        }
        allVenues[position].used = true
        return venues[position]
        
    }
    
}
