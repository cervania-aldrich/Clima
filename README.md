![App Brewery Banner](Documentation/AppBreweryBanner.png)

#  Clima

## Description
This is a weather app, where users can check the weather by searching for a city manually or by using the current location of the user using the GPS data from the iPhone. 

I created this app as part of the [App Brewery's "Complete iOS App Development Bootcamp'' course on Udemy](https://www.udemy.com/course/ios-13-app-development-bootcamp/).

Building on the lessons from the previous module [BMI Calculator](https://github.com/cervania-aldrich/BMI-Calculator), the MVC pattern was implemented but in this module we learn about a new design pattern called the delegate design pattern using protocols. This is the first app I have built where I use a public web-based API to get live data from the internet and learned about the process called networking and learned how to work with that data in our app.

I personally feel that building this app was a big jump in difficulty from the previous module, but I learned a lot. I started to get more confident when I used other resources such as freecodecamp to understand APIs, in addition to rewatching the sections I was confused with, several times. Advanced concepts from BMI Calculator (e.g. classes, inheritance, dealing with optionals, etc) were tested and putting them together with new concepts from this module (e.g. delegate pattern, networking, completion handler, etc) were reasons why I found this module challenging. However, it was incredibly rewarding when I finished the app as well as innovated on top of it. 

As this app was made for learning purposes, I have added many comments and documentation markup in order to be as descriptive as possible. It has been an effective learning strategy for me. I found this has helped me understand the Swift language and the Apple Developer documentation better. Also, it helped me not fall into the trap of just copying code from a tutorial, rather I’m reassuring myself that I actually understand the code being written and why it was written. Furthermore, I recognise that documenting code is an important skill to have as a Software Developer, and I believe it is worth practising.

## Instructions
Clone this repository in Xcode to run the project. Run it in the simulator.

You must acquire your own API key from OpenWeather API for this app to be functional. Create a free account at [openweather](https://openweathermap.org/) to access your API key. 

Once you have activated your API key (which may take up to a few hours to be activated), then set the “apiKey” variable in the “ConstantsAPIKey” file to your API key. Ensure that the API key is accurate, otherwise the request will fail and you will receive a 401 response error.

## Learning Objectives
What did I learn? How did this app improve my iOS development skills?

There are several concepts that I was able to learn whilst developing this app. This includes:

* How to use public APIs to get live data from the internet.
* Learn about Networking, and use the native URLSession object to make HTTP requests to a server.
* Learn about the Decodable Protocol and how to parse JSON formatted data using the native JSONDecoder.
* Learn to create Dark Mode differentiated assets and use vector assets.
* Learn to use the UITextField to get keyboard inputs.
* Learn about Swift Protocols.
* Learn about the Delegate Design Pattern.
* Learn about Swift Extensions.
* Learn about Swift computed properties.
* Understand the completion handler and the Swift Closure.
* Learn about Core Location to tap into the device GPS data.
    
## What makes this project stand out?
To improve my understanding, I added extra features to the app. This includes:

* Be able to search for city names with spaces and accentuated characters (E.g New York, San José).
* Add a gesture recognizer, such that the user can tap outside the keyboard to dismiss the keyboard.
* Refactor urlString to make the string more URL safe - The reference to the API call is broken down using the native URLComponents and URLQueryItems objects.
* Add a new delegate method to pass the response status code to the WeatherViewController.
* Add a constants file to manage strings in a central place.
* Add comments to help explain my code.
* Use the DocC framework to add Swift documentation to guide end-users reviewing the code.

>This is a companion project to The App Brewery's Complete App Development Bootcamp, check out the full course at [www.appbrewery.co](https://www.appbrewery.co/)

![End Banner](Documentation/readme-end-banner.png)

