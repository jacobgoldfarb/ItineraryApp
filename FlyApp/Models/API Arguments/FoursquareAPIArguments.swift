//
//  Parameters.swift
//  FlyApp
//
//  Created by Jacob Goldfarb on 2018-02-19.
//  Copyright © 2018 JacobGoldfarb. All rights reserved.
//
//This class is responsible for getting and storing the parameters for each Foursquare API call.
//As of now there is one instance of this class for each of the 5 types of parameters. This can be changed to one instance for each venue.
//Once instance will always correspond with one Foursquare API call.
//Each endpoint has its own type of arguments stored for every call.
import Foundation

class FoursquareAPIArguments{
    
    var parameter:Paramater
    var price:Int
    var near:String
    var categories:String
    var query:String
    var type:ArgumentType

    init(){
        parameter.name = ""
        parameter.value = 0
        price = 0
        near = ""
        categories = ""
        query = ""
        type = .exploreQuery
    }
    convenience init(param:Paramater, budget:Int, destination:String) {
        self.init()
        parameter.name = param.name
        parameter.value = param.value
        price = budget
        near = destination
        
        categories = ""
        
        categories = getCategories()
        query = getQueries()
    }
    ///This function returns the number of venues the API should return for each type of parameter.

    func getCategories() -> String{
        switch parameter.name {
        case "nightlifeLevel":
            return "4bf58dd8d48988d1f1931735" //General Entertainment
        case "cultureLevel":
            return "5267e4d9e4b0ec79466e48c7" //Festival
        case "parksLevel":
            return "4bf58dd8d48988d163941735" //Park
        case "historyLevel":
            return "4bf58dd8d48988d181941735" //Museum
        case "shoppingLevel":
            return "4d4b7105d754a06378d81259"
        case "hotel":
            return price > 1 ? "4bf58dd8d48988d1fa931735" : "4bf58dd8d48988d1ee931735" //Hotel or Hostel
        default:
            return ""
        }
    }
    
    func getQueries() -> String{
        
        switch parameter.name {
        case "nightlifeLevel":
            type = .exploreQuery
            return "bar" //General Entertainment
        case "cultureLevel":
            type = .exploreSection
            return "sights" //Festival
        case "parksLevel":
            type = .exploreSection
            return "outdoors" //Park
        case "historyLevel":
            type = .exploreSection
            return "arts" //Museum
        case "shoppingLevel":
            type = .exploreSection
            return "shops"
        case "hotel":
            type = .exploreSection
            return price > 1 ? "hotel" : "hostel" 
        default:
            return ""
        }
    }
    func printInfo(){
        print("-----------Foursquare Parameters: \(parameter.name)------------")
        print("Parameter: \(parameter.name)")
        print("Price: \(price)")
        print("Near: \(near)")
        print("Categories: \(categories)")
        print("------------------------------------")
    }
    
    
}
/*NIGHT LIFE
 - HIGH
 - Casino: 4bf58dd8d48988d17c941735
 - Comedy Club: 4bf58dd8d48988d18e941735
 - General Entertainment: 4bf58dd8d48988d1f1931735
 - Jazz Club: 4bf58dd8d48988d1e7931735
 - Piano Bar: 4bf58dd8d48988d1e8931735
 - LOW
 - Performing Arts Venue: 4bf58dd8d48988d1f2931735
 
 * CULTURE
 - Christmas Market: 52f2ab2ebcbc57f1066b8b3b
 - Festival: 5267e4d9e4b0ec79466e48c7
 - Music Festival: 5267e4d9e4b0ec79466e48d1
 - Other Event: 5267e4d9e4b0ec79466e48c8
 - Parade: 52741d85e4b0d5d1e3c6a6d9
 - Street Fair: 5267e4d8e4b0ec79466e48c5
 
 * PARKS
 - Botanical Garden: 52e81612bcbc57f1066b7a22
 - Cave: 56aa371be4b08b9a8d573511
 - Garden: 4bf58dd8d48988d15a941735
 - Hot Spring: 4bf58dd8d48988d160941735
 - Park: 4bf58dd8d48988d163941735
 - Sculpture Garden: 4bf58dd8d48988d166941735
 
 * MUSEUM
 - Art Studio: 58daa1558bbb0b01f18ec1d6
 - Museum: 4bf58dd8d48988d181941735
 - Art Gallery: 4bf58dd8d48988d1e2931735
 - Historic Site: 4deefb944765f83613cdba6e
 
 * SHOPPING
 - Shopping & Service: 4d4b7105d754a06378d81259
 
 */
