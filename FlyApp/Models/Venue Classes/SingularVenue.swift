//
//  Venue.swift
//  FlyApp
//
//  Created by Jacob Goldfarb on 2018-03-03.
//  Copyright © 2018 JacobGoldfarb. All rights reserved.
//

import Foundation
import SwiftyJSON

///Each instance of this struct should store only one venue.
struct SingularVenue{
    
    //All this information is fetched with venues/explore
    var venueID:String
    var parameter:Paramater
    var city:String
    var name:String
    
    var used:Bool
    
   // var photosURL:String
    var rating:Double
    
    struct Address{
        var displayAddress:JSON
        var latitude:Double
        var longitude:Double
    }
    var address:Address
    
    //This information is fetched with venues/hours/VENUE_ID
    struct openTimeframe{
        var openHour = [Int]()
        var closeHour = [Int]()
        var openDays = [Int]()
    }
    struct popularTimeframe{
        var popularOpening:Int
        var popularClosing:Int
        var popularDays = [[Int]]()
    }
    
    func printInfo(){
        print("-------------- For Parameter: \(parameter) --------------")
        print("Venue ID's: \(self.venueID)")
        print("Address's: \(self.address)")
        print("Names: \(self.name)")
        print("Ratings: \(self.rating)")
        print("------------------------------------")
    }
}
