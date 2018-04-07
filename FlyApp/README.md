
#  Unnamed Itinerary Generation App

## Brief
This is an Itingerary Generation App. A user can describe parameters (including a city name, and vacation departure and arrival dates)  and preferences (including levels of affection towards categories of activities) which are then used to create an itinerary.

## UI Walkthrough

1. The user is greeted, and a walkthrough is presented
- The user fills out each category and field.
- The user then signs into or registers an account (To be developed)
-   OR A partial itinerary is generated before a register account prompt.
-   OR A the user can restore his previous purchase

2. An itinerary is generated
- The user can save it to a file with document chooser, etc.
- The

## Structure

This program uses Model-View-Controller architecture design paradigm. The views are placed in .storyboard files. Model classes never import UIKit and theoretically should be able to be ported to a macOS applicaiton.

C = calls
R = replaces
Variable names, e.g. struct, var, protocol, func or class is assumed.

`ViewController` R -> `IntroView` R -> `ViewController`
C -> `Trip` C -> `FoursquareAPIArguments` x parameters
        `Trip` C -> `VenueCall` x parameters -> C Struct `SingularVenue` x venues in trip
        `Trip` C -> `Timetable` x days of trip
        
## Class Overviews

### Intro View
- *Methods*
The user selects each
        
        
        
        
        
