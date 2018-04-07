//
//  ReferenceTimes.swift
//  FlyApp
//
//  Created by Jacob Goldfarb on 2018-02-24.
//  Copyright © 2018 JacobGoldfarb. All rights reserved.
//

import Foundation

//Reference times, how long each time unit is in seconds.
let minute_:TimeInterval = 60
let quarterHour_:TimeInterval = 60 * 15
let halfHour_:TimeInterval = 60 * 30
let hour_:TimeInterval = 60 * 60
let halfDay_:TimeInterval = 60 * 60 * 12
let day_:TimeInterval = 60 * 60 * 24
let week_:TimeInterval = 60 * 60 * 24 * 7
let year_:TimeInterval = 60 * 60 * 24 * 7 * 52

typealias Paramater = (name:String, value:Int)

extension Date
{
    func toString(dateFormat format: String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
        
    }
    var displayDate:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    var noon:Date{
        let gregorian = Calendar(identifier: .gregorian)
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        
        components.hour = 12
        components.minute = 0
        components.second = 0
        return gregorian.date(from: components)!
    }
    
    //MARK: Time of day.
    ///Returns the current date.
    var today:Date{
        let date = Date()
        let calendar = Calendar.current
        _ = calendar.component(.hour, from: date)
        _ = calendar.component(.minute, from: date)
        return date
    }
    var timezone:TimeZone{
        return TimeZone.current
    }
    
    ///Returns midnight by finding midnight at UTC 0 and adding the hour difference.
    var midnight:Date{
        
        
        let cal = Calendar(identifier: .gregorian)
        return cal.startOfDay(for: self)
    }
    ///If this var returns true, then daylight savings time is active and an hour of daylight is gained (during the summer).
    var isDaylightSavings:Bool{
        return timezone.daylightSavingTimeOffset(for: self) == 0 ? false : true
    }
    var daylightSavings:Double{
        return isDaylightSavings ? 3600.0 : 0.0
    }
    
    //MARK: Overloaded Operators
    ///Gets the difference between two dates.
    static func -(left: Date, right: Date) -> TimeInterval { // 1
        
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([ .second])
        let datecomponenets = calendar.dateComponents(unitFlags, from: right, to: left)
        let seconds = TimeInterval(datecomponenets.second!)
        return seconds
    }
    ///Simpler way to add time to a date.
    static func +(left: Date, right: TimeInterval) -> Date {
        
        return(left.addingTimeInterval(right))
    }
    static func +(left: Date, right: Int) -> Date {
        
        return(left.addingTimeInterval(TimeInterval(right)))
    }
    ///Simple way to remove time from a date.
    static func -(left: Date, right: TimeInterval) -> Date {
        
        return(left.addingTimeInterval(right*(-1)))
    }
}
//MARK: Useful global Functions

///Used for delaying method calling, useful since data from Foursquare API is not instantly retrievable.

func delay(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}
