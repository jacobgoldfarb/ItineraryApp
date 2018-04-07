//
//  VenueModel.swift
//  FlyApp
//
//  Created by Jacob Goldfarb on 2018-02-12.
//  Copyright © 2018 JacobGoldfarb. All rights reserved.
//
import Foundation
import SwiftyJSON
import FoursquareAPIClient


enum ArgumentType{
    case searchRecommendations //Search endpoint
    case exploreQuery //Explore endpoint with a query parameter
    case exploreSection //Explore endpoint with section parameter
    case venuesSearch
}
///Each object stores an array of 50 SingularVenue elements relating to the passed in FoursquareAPIArguments instance.
class VenueCall{
    
    var totalVenues:Int
    var usageCount:Int
    
    var city:String
    var category:String
    
    var venues = [SingularVenue]()
    var parameter:Paramater
    
    var arguments = [String: String]()
    var endpoint:String
    var endpointType:ArgumentType
    var offset:Int
    fileprivate var clientSecret = "42FPPLOTJ3HDFFCIUKLWSE2FV5KFIXYAIE3GU2ILN41BSPQL"
    fileprivate var clientID = "JMBLK0SDZ0N2NF5TG3UCLMOF4FA5FKA14AIOZ4P4TS4MHEWO"
    
    init(params: FoursquareAPIArguments, withType argumentType: ArgumentType) {
        
        city = params.near
        category = params.categories//parseParameter(parameter: paramLabel)
        parameter.name = params.parameter.name
        parameter.value = params.parameter.value
        totalVenues = 0
        usageCount = 0
        endpointType = argumentType
        offset = 0
        
        switch argumentType {
        case .exploreQuery,
             .exploreSection:
            endpoint = "venues/explore"
        case .searchRecommendations:
            endpoint = "search/recommendations"
        case .venuesSearch:
            endpoint = "venues/search"
        }
        arguments = makeArguments(withType: argumentType, andParams: params)
        
        getObjects(withArguments: arguments)
        
    }
    
    
    //MARK: Print Functions
    func printVenueCallInfo(){
        print(" ")
        print("-------------- For Parameter: \(parameter.name) --------------")
        print("categories: \(self.category)")
        print("Usage: \(self.usageCount)")
        print("Total Venues for Parameter: \(self.totalVenues)")
        print(" ")
    }
    func printVenueInfo(){
        print("-------------- \(totalVenues) Venues for Parameter: \(parameter.name) --------------")
        for venue in venues{
            print("")
            print("Venue: \(venue.name)")
            print("Address: \(venue.address)")
            print("ID: \(venue.venueID)")
        }
    }
    
    //MARK: Parsing Functions
    func parseSearch(jsonObject:JSON){
        for object in jsonObject["response"]["group"]["results"].arrayValue{
            totalVenues += 1
            let newVenue = SingularVenue.init(venueID: object["id"].stringValue, parameter: parameter, city: city, name: object["venue"]["name"].stringValue, used: false, rating: object["venue"]["rating"].doubleValue, address: parseAddress(from: object["venue"]["location"]))
            venues.append(newVenue)
        }
    }
    func parseExplore(jsonObject:JSON){
        
        print("-----------JSON for \(parameter.name) --------------")
        for object in jsonObject["response"]["groups"].arrayValue{
            for subObject in object["items"].arrayValue{
                totalVenues += 1
                let newVenue = SingularVenue.init(venueID: subObject["venue"]["id"].stringValue, parameter: parameter, city: city, name: subObject["venue"]["name"].stringValue, used: false, rating: subObject["venue"]["rating"].doubleValue, address: parseAddress(from: subObject["venue"]["location"]))
                venues.append(newVenue)
            }
        }
        self.printVenueInfo()
    }
    func parseVenuesSearch(jsonObject:JSON){
        
        print("-----------JSON for \(parameter.name) --------------")
        for object in jsonObject["response"]["venues"].arrayValue{
            totalVenues += 1
            let newVenue = SingularVenue.init(venueID: object["id"].stringValue, parameter: parameter, city: city, name: object["name"].stringValue, used: false, rating: -1, address: parseAddress(from: object["location"]))
            venues.append(newVenue)
        }
        self.printVenueInfo()
    }
    func parseAddress(from object: JSON) -> SingularVenue.Address{
        
        switch endpointType{
        case .exploreQuery,
             .exploreSection,
             .searchRecommendations:
            return SingularVenue.Address.init(displayAddress: object["address"], latitude: object["lat"].doubleValue, longitude: object["lng"].doubleValue)
        case .venuesSearch:
            return SingularVenue.Address.init(displayAddress: object["displayAddress"], latitude: object["lat"].doubleValue, longitude: object["lng"].doubleValue)
        }
    }
    
    //MARK: API Call Functions
    
    func getObjects(withArguments arguments: [String:String]){
        let client = FoursquareAPIClient(clientId: clientID, clientSecret: clientSecret)
        
        //In the future use a different endpoint with different limits and categories to optimize results.
        client.request(path: endpoint, parameter: arguments) { result in
            switch result {
            case let .success(data):
                guard let json = try? JSON(data: data) else{
                    print("\(#function): Unable to retrieve json object")
                    return
                }
                print("Success")
                if json["meta"]["code"] == 200{
                    self.offset += 1
                    if(self.parameter.name == "hotel"){print(json)}
                    switch (self.endpointType) {
                    case .exploreQuery,
                         .exploreSection:
                        self.parseExplore(jsonObject: json)
                    case .searchRecommendations:
                        self.parseSearch(jsonObject: json)
                    case .venuesSearch:
                        self.parseVenuesSearch(jsonObject: json)
                    }
                }
            case let .failure(error):
                // Error handling
                switch error {
                case let .connectionError(connectionError):
                    print(connectionError)
                case let .responseParseError(responseParseError):
                    print(responseParseError)   // e.g. JSON text did not start with array or object and option to allow fragments not set.
                case let .apiError(apiError):
                    print(apiError.errorType)   // e.g. endpoint_error
                    print(apiError.errorDetail) // e.g. The requested path does not exist.
                }
            }//end switch
        }//end client.request
        
    }
    func makeArguments(withType argument: ArgumentType, andParams params:FoursquareAPIArguments) -> [String:String]{
        
        var parameter = [String:String]()
        
        parameter["near"] = params.near
        parameter["limit"] = "50"
        switch argument {
        case .searchRecommendations:
            parameter["categoryId"] = category
            parameter["price"] = String(describing: params.price)
        case .exploreQuery:
            parameter["query"] = params.query
            parameter["price"] = String(describing: params.price)
        case .exploreSection:
            parameter["section"] = params.query
            parameter["price"] = String(describing: params.price)
        case .venuesSearch://This endpoint is problematic since you can't specify a budget.
            parameter["categoryId"] = params.categories
        }
        return parameter
    }
    
}

