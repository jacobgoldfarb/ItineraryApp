//
//  Timetable+OtherEventPopulation.swift
//  FlyApp
//
//  Created by Jacob Goldfarb on 2018-03-20.
//  Copyright © 2018 JacobGoldfarb. All rights reserved.
//

import Foundation

//Determines all non-venue based events.
extension Timetable{
    func getDayEnds(withActivity journeysPerDay:Int){
        
        self.journeysPerDay = journeysPerDay
        wakeup = getWakeup(withActivity: journeysPerDay)
        bedtime = getBedtime()
        
        
    }
    func getWakeup(withActivity activity: Int) -> Event{
        
        var wakeupTime = instanceDate.addingTimeInterval(hour_*8) //Init wakeupTime is 8:00AM.
        let sleepIn = isFirstDay ? 0 : getSleepIn(activity: activity)
        wakeupTime = wakeupTime.addingTimeInterval(sleepIn)
        let wakeup = Event(description: "Start time", startTime: wakeupTime, endTime: nil, venue: nil)
        return wakeup
    }
    func getSleepIn(activity: Int) -> TimeInterval{
        var sleepIn:TimeInterval = 0
        
        if(yesterday!.bedtime.startTime > instanceDate){//If yesterday's bedtime is later than 12:00AM...
            sleepIn = yesterday!.bedtime.startTime.timeIntervalSince(instanceDate)//Gets the how many minutes past midnight the last event was.
        }
        //More obvious: "sleepIn += hour_ - (activity - 2) * (hour_ / 3)" Adds a sleep in based on activity level. Activity level '1' is a sleep in of 1 hour, '2' is 40 minutes, '3' is 20 minutes, and '1' is no sleep in.
        
        sleepIn += hour_ * ((5 - Double(activity))/3)
        return sleepIn
    }
    
    func getBedtime() -> Event{
        let bedtimeDate = Date()
        let bedtime = Event(description: "End time", startTime: bedtimeDate.midnight.addingTimeInterval(hour_*22), endTime: nil, venue: nil)
        return bedtime
    }
    func getMealtimes(){
        
    }
}
