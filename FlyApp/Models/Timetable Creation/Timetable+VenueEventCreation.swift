//
//  Timetable+VenueEventCreation.swift
//  FlyApp
//
//  Created by Jacob Goldfarb on 2018-03-20.
//  Copyright © 2018 JacobGoldfarb. All rights reserved.
//

import Foundation

//Responsible for determining the start time, end time, etc. for the venue based events.
extension Timetable{
    
    func getVenueStart(journeysPerDay: Int, position: Int, nightlife: Bool) -> Date{
        
        if(nightlife){
            return instanceDate + hour_*22 //As of now, nightlife events are always at 10:00 PM
        }
        /*
        var startTime = wakeup.startTime
        
        if(journeysPerDay == 2){
            switch position {
            case 0:
                startTime += hour_*1.5
            case 1:
                startTime += hour_*5
            default:
                print("Unspecified case, where journeysPerDay is \(journeysPerDay), and position is \(position)")
            }
        }
        else if(journeysPerDay == 3){
            switch position {
            case 0:
                startTime += hour_*1.5
            case 1:
                startTime += hour_*3
            case 2:
                startTime += hour_*5.5
            default:
                print("Unspecified case, where journeysPerDay is \(journeysPerDay), and position is \(position)")
            }
        }
        else if(journeysPerDay == 4){
            switch position {
            case 0:
                startTime += hour_*1 //
            case 1:
                startTime += hour_*3
            case 2:
                startTime += hour_*5
            case 3:
                startTime += hour_*7
            default:
                print("Unspecified case, where journeysPerDay is \(journeysPerDay), and position is \(position)")
            }
        }
        else if(journeysPerDay == 5){
            switch position {
            case 0:
                startTime += hour_*0.5
            case 1:
                startTime += hour_*2
            case 2:
                startTime += hour_*5
            case 3:
                startTime += hour_*7
            case 3:
                startTime += hour_*9
            default:
                print("Unspecified case, where journeysPerDay is \(journeysPerDay), and position is \(position)")
            }
        }
        return startTime
 */
        return wakeup.startTime
    }
    func sortEventsByTime(allEvents: [Event]) -> [Event]{
        return allEvents.sorted(by: {$0.startTime < $1.startTime})
    }
}
