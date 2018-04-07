//
//  TimeTable.swift
//  FlyApp
//
//  Created by Jacob Goldfarb on 2018-02-14.
//  Copyright © 2018 JacobGoldfarb. All rights reserved.
//
//This class will handle the time table. Each object will represent one day of the trip.
//TODO: Determine how venue hours play into timetable, and how nightclubs events/how late the previous time table is affects the next time table.

import Foundation


class Timetable{
    
    struct Event{
        var description:String
        var startTime:Date
        var endTime:Date? //If no end time is given, then the event is simply an instance, e.g. "Wakeup"
        var venue:SingularVenue?
    }

    let mealsPerDay = 3
    let secondsPerDay = 86400
    
    var instanceDate:Date//The day of this time table.
    var bedtime:Event
    var wakeup:Event
    
    //var dayOfWeek:Int //Stores the corresponding day of the week for the object where 0 is Sunday, 1 is Monday, and so on.
    
    var eventTimes = [Event]() //Stores every event in the day.
    
    var allVenues = [SingularVenue]()//Stores every venue used in the day's venue events.
    var venueEvents = [Event]()//Stores only the events with venues.

    var isFirstDay:Bool
    var day:Int
    var journeysPerDay:Int
    
    var yesterday:Timetable?
    
    ///- Parameter inDate: The first date of the trip.
    ///- Parameter tripLength: How many days long the trip is.
    ///- Parameter offset: How many days into the trip this timetable represents. E.g., if the offset is 0 then this timetable represents the first date of the trip, the in date. If offset is 1, this timetable is for the second day of the trip.
    ///Initializes values to be mutated: Wakeup, bedtime.
    ///Initializes final values: instanceDate, isFirstDay.
    init(inDate: Date, tripLength:Int, offsetBy offset: Int){
        instanceDate = inDate.midnight.addingTimeInterval(TimeInterval(86400*offset))
        wakeup = Event(description: "Wakeup", startTime: instanceDate.addingTimeInterval(hour_*8), endTime: nil, venue: nil)
        bedtime = Event(description: "Bedtime", startTime: instanceDate.addingTimeInterval(hour_*22), endTime: nil, venue: nil)
        day = offset + 1
        isFirstDay = offset > 0 ? false : true
        journeysPerDay = 0
    }
    
    ///Sorts all the events from earliest to latest.

    func orderVenues(_ venues: [SingularVenue]) -> [SingularVenue]{
        
        var sortedVenues = [SingularVenue]()
        var venuesToSort = venues
        //Removes the nightlife venue from the array.
        for (index, venue) in venuesToSort.enumerated(){
            if(venue.parameter.name == "nightlifeLevel"){
                venuesToSort.remove(at: index)
                break
            }
        }
        let selectedVenue = venuesToSort[0]
        venuesToSort.remove(at: 0)
    
        while(sortedVenues.count < allVenues.count - 1){
            var distancesFromVenue = [(distance: Double, venue: SingularVenue, index: Int)]()
          //  var venueToRemvoveIndex:Int?
            for (index, venue) in venuesToSort.enumerated(){
                let venueInfo = (distance: getEuclidianDistance(between: venue, and: selectedVenue), venue: venue, index: index)
                distancesFromVenue.append(venueInfo)
            }
            distancesFromVenue = distancesFromVenue.sorted(by: {$1.distance > $0.distance})
            sortedVenues.append(distancesFromVenue[0].venue)
            venuesToSort.remove(at: distancesFromVenue[0].index)
        }
        return sortedVenues
    }
    ///Calls methods in Timetable+VenueEventCreation extension.
    func getVenueEvents(forVenues venues: [SingularVenue]) -> [Event]{
        
        var allVenueEvents = [Event]()
    
        for (position, venue) in venues.enumerated(){
            let description = "\(venue.name), \(venue.parameter)"
            let startTime = getVenueStart(journeysPerDay: journeysPerDay, position: position, nightlife: venue.parameter.name == "nightlife" ? true: false)
            let endTime = startTime + 1*hour_ + 1/journeysPerDay
            let venueEvent = Event(description: description, startTime: startTime, endTime: endTime, venue: venue)
            allVenueEvents.append(venueEvent)
        }
        return venueEvents
    }

    ///Determines the day of the week each day corresponds to, 1 corresponds to Sunday, 2 -> Monday, 3 -> Tuesday, and so on.
    func getDayOfWeek(from instanceDate: Date) -> Int{
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)
        let weekday = gregorianCalendar!.component(.weekday, from: instanceDate) - 1
        
        return weekday
    }
}

//MARK: Print Methods
extension Timetable{
    func printAllVenues(){
        print("--------All Venues for \(instanceDate) of the trip---------------")
        print("(there should be \(journeysPerDay) venues, and there are \(allVenues.count) venues)")
        for venue in allVenues{
            print("Venue type:\(venue.parameter)")
            print("Venue name: \(venue.name)")
        }
    }
    func printInfo(){
        //print("--------Info for \(instanceDate)-----------------")
        print("Wakeup \(wakeup)")
        print("Events \(eventTimes)")
        print("Bedtime \(bedtime)")
        print("Yesterday's Bedtime \(String(describing: yesterday?.bedtime))")
        print("Venues: \(venueEvents)")
        //print("----------------------------------------------")
    }
}
