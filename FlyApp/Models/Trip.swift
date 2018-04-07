//
//  VenueInformationModel.swift
//  FlyApp
//
//  Created by Jacob Goldfarb on 2018-01-28.
//  Copyright © 2018 JacobGoldfarb. All rights reserved.


import Foundation

/// `Trip` is responsible for
/// - Calling all the methods and creating objects that create the arguments for the API calls
/// - Fetch all the venues to be used in the trip
/// - Create timetables for each day in the trip.
/// - Parse the user's presets from the IntroView.
class Trip{
    
    var allVenues = [SingularVenue]()
    var day = [Timetable]()
    var hotel:SingularVenue?
    
    var paramLevels = [String: Int]()
    var foursquareParameters = [String: FoursquareAPIArguments]()
    
    private var venueLists = [String: VenueCall]()
    private var sortedInfo = [Paramater]()//Stores all the user's paramaters for each category.
    private var params = [FoursquareAPIArguments]()//Stores paramaters for the Foursquare API request.
    
    //Return Variables
    init(){
        //Gets parameters related to categories.
        paramLevels["nightlife"] = UserDefaults.standard.integer(forKey: "nightlife")
        paramLevels["culture"] = UserDefaults.standard.integer(forKey: "culture")
        paramLevels["parks"] = UserDefaults.standard.integer(forKey: "parks")
        paramLevels["history"] = UserDefaults.standard.integer(forKey: "history")
        paramLevels["shopping"] = UserDefaults.standard.integer(forKey: "shopping")
        let hotelBudget = UserDefaults.standard.integer(forKey: "hotel")

        sortedInfo = sortDictionary(paramLevels) //Stores the sotred parameter levels into an appropriate array of tuples.
    }
    func createTrip(){
        //Gets parameters unrelated to categories.
        let budget = UserDefaults.standard.integer(forKey: "budget")
        let activityLevel = UserDefaults.standard.integer(forKey: "activity")
        let destination = UserDefaults.standard.string(forKey: "destination")!
        let inDate = UserDefaults.standard.value(forKey: "firstDate") as! Date
        let outDate = UserDefaults.standard.value(forKey: "secondDate") as! Date
        
        //MARK: Getting and calculating important variables.
        let journeysPerDay = calculateJourneys(usingActivityLevel: activityLevel) //Stores how many journeys there should be each day.
        let tripLength = getTripLength(from: inDate, to: outDate)//Stores how long, in days, the trip is.
        print("TRIP LENGTH: \(tripLength)")
        getParameters(budget: budget, destination: destination)
        
        // Uncomment to fetch venues from API.
        fetchVenues() //Gets all the venues for the trip.
        
        delay(5){
            self.createTimeTables(forDate: inDate, forLength: tripLength, journeysPerDay: journeysPerDay) //Creates the time table for each day of the trip.
        }
    }
    
    
    ///Simply calculates how many journeys should take place each day by adding 2 to the user's activity level, or, by default, setting it as 4.
    ///The relevant parameter here is `journeysPerDay`.
    func calculateJourneys(usingActivityLevel activityLevel: Int) -> Int{
        if(activityLevel != 0){
            return activityLevel + 1 //Number of activities, not including meals, the user partakes in.
        }
        else{
            return 4
        }
    }
    
    ///Determines the trip length, in days. Also determines which day of the week each trip day corresponds to.
    func getTripLength(from inDate: Date,to outDate: Date) -> Int {
        let timeLength:Double = outDate.timeIntervalSince(inDate) //In seconds
        return Int(timeLength/day_ + 1) //Trip length in days
    }
    
    ///Stores the appropriate information in each parameter object.
    func getParameters(budget: Int, destination: String){
        foursquareParameters["nightlife"] = FoursquareAPIArguments(param: (name: "nightlife", value:  paramLevels["nightlife"]!),budget: budget, destination: destination)
        foursquareParameters["culture"] = FoursquareAPIArguments(param: (name: "culture", value:  paramLevels["culture"]!), budget: budget, destination: destination)
        foursquareParameters["parks"] = FoursquareAPIArguments(param: (name: "parks", value:  paramLevels["parks"]!), budget: budget, destination: destination)
        foursquareParameters["history"] = FoursquareAPIArguments(param: (name: "history", value:  paramLevels["history"]!), budget: budget, destination: destination)
        foursquareParameters["shopping"] = FoursquareAPIArguments(param: (name: "shopping", value:  paramLevels["shopping"]!), budget: budget, destination: destination)
        foursquareParameters["hotel"] = FoursquareAPIArguments(param: (name: "hotel", value: -1), budget: budget, destination: destination)

//        for i in 0..<sortedInfo.count{
//            let param = FoursquareAPIArguments(param: sortedInfo[i].param, budget: budget, destination: destination)
//            print("paramter: \(i) \(sortedInfo[i].param)")
//            params.append(param)
//        }
    }
    
    func fetchVenues(){
    
        //Makes a list of venues for every parameter, finds the venues for each parameter, and adds them to the list of allVenues.
        venueLists["nightlife"] = VenueCall(params: foursquareParameters["nightlife"]!, withType: .exploreQuery)
        venueLists["culture"] = VenueCall(params: foursquareParameters["culture"]!, withType: .exploreSection)
        venueLists["parks"] = VenueCall(params: foursquareParameters["parks"]!, withType: .exploreSection)
        venueLists["history"] = VenueCall(params: foursquareParameters["history"]!, withType: .exploreSection)
        venueLists["shopping"] = VenueCall(params: foursquareParameters["shopping"]!, withType: .exploreSection)
        venueLists["hotel"] = VenueCall(params: foursquareParameters["hotel"]!, withType: .venuesSearch)

        delay(2.5){
            self.allVenues.append(contentsOf: self.venueLists["nightlife"]!.venues)
            self.allVenues.append(contentsOf: self.venueLists["culture"]!.venues)
            self.allVenues.append(contentsOf: self.venueLists["parks"]!.venues)
            self.allVenues.append(contentsOf: self.venueLists["history"]!.venues)
            self.allVenues.append(contentsOf: self.venueLists["shopping"]!.venues)
            self.allVenues.append(contentsOf: self.venueLists["hotel"]!.venues)
            
          //  self.allVenues = self.allVenues.redu
        }
        
        //TODO: Add hotel budget slider?
        delay(2.7){
            print("Hotel Venues")
            self.venueLists["hotel"]!.printVenueInfo()
            print("-------")
            self.findDuplicateVenues()
        }
    }
    func createTimeTables(forDate inDate:Date, forLength tripLength:Int, journeysPerDay:Int){
        //For Feb 28 - March 3rd, default values
        print("In date: \(inDate), trip length: \(tripLength), journeys per day: \(journeysPerDay)")
        for day in 0...tripLength-1{
            print("|---- Day: \(day) --------|")
            let timeTable = Timetable(inDate: inDate, tripLength: tripLength, offsetBy: day)
            timeTable.yesterday = day > 0 ? self.day[day-1] : nil
            timeTable.getDayEnds(withActivity: journeysPerDay)
            
            var onlyVenueLists = [VenueCall]()
            for(key,value) in venueLists{
                onlyVenueLists.append(value)
            }
            
            
            timeTable.populateVenues(forAll: onlyVenueLists, with: sortedInfo)
            timeTable.printAllVenues()
            self.day.append(timeTable)
        }
    }
    //MARK: Eliminate duplicate venues methods.
    func findDuplicateVenues(){
        
    
        for (i, venue1) in allVenues.enumerated(){
            for (j, venue2) in allVenues.enumerated(){
                if((venue1.venueID == venue2.venueID)&&(j != i)){
                    print("""
                        Found duplicate venue called \(venue1.name), which is in allVenues at index \(i), and at index \(j)
                    """)
                    removeDuplicateVenues(venue1: venue1, venue2: venue2)
                }
            }
        }
    }
    func removeDuplicateVenues(venue1: SingularVenue, venue2: SingularVenue){
        
        let param1ListCount = venueLists[venue1.parameter.name]?.totalVenues ?? 0
        let param2ListCount = venueLists[venue1.parameter.name]?.totalVenues ?? 0
        
        var venueToRemove:SingularVenue
        
        if(param1ListCount > param2ListCount){//Check which list is longer.
            venueToRemove = venue1
        }
        else if(param2ListCount > param1ListCount){
            venueToRemove = venue2
        }
        else if(venue1.parameter.value > venue2.parameter.value){//Check which parameter the user favours more.
            venueToRemove = venue2
        }
        else if(venue1.parameter.value < venue2.parameter.value){
            venueToRemove = venue1
        }
        else{//Otherwise, remove a random venue.
            venueToRemove = arc4random_uniform(2) == 1 ? venue1 : venue2
        }
        
        for (i, venue) in allVenues.enumerated(){
            if(venue.venueID == venueToRemove.venueID)&&(venue.parameter.name == venueToRemove.parameter.name){
                print("Removed venue called \(venue.name) from \(venue.parameter.name)")
                allVenues.remove(at: i)
            }
        }

    }
}
extension Trip{
    ///Sorting algorithm. Accepts a key, value dictionary and then returns them as a tuple sorted by descending values.
    ///- Parameter toSort: The dictionary which is sorted via a simple Bubble Sort
    ///- Returns: A sorted tuple with named pairs, `param` of type String, and `value` of type Int.
    func sortDictionary(_ toSort: [String: Int]) -> [(name: String, value: Int)]{
        
        var sortedArray: [(name: String, value: Int)] = []
        for (key,value) in toSort{
            let tupleArrayElement:Paramater = (name: key, value: value)
            sortedArray.append(tupleArrayElement)
        }
        let returnArray = sortedArray.sorted(by: {$0.value < $1.value})
        return returnArray
    }
}

