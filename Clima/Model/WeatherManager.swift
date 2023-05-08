import Foundation
import CoreLocation

///The methods that you use to recieve events from making an API call to OpenWeather, such as recieving data, errors and responses of the request.
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, _ weather:WeatherModel)
    func didFailWithError(_ weatherManager:WeatherManager, _ error: Error)
    func didRecieveErrorWithResponse(_ weatherManager:WeatherManager, _ response: URLResponse)
}

///A struct that handles the networking process. Requesting information from the api, and then using the native JSON decoder to parse that JSON file in a Swift Object. 
struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather"
    let apiKey = "a210b6f91c665d2db9eb566589c6c2aa"
    let unitOfMeasurement = "metric"
    
    func fetchWeather(for cityName:String){
        
        //URLComponents already contains the proper percent encoding. Using this object results in more safe code for networking.
        
        guard var urlComponent = URLComponents(string: weatherURL) else { return } //Create URL
        urlComponent.scheme = "https"
        urlComponent.queryItems = [URLQueryItem(name: "q", value: cityName),
                                   URLQueryItem(name: "appid", value: apiKey),
                                   URLQueryItem(name: "units", value: unitOfMeasurement)] //Create queries, and add them to the URL.
        
        let urlString = urlComponent.url!.absoluteString //Reference to the URLComponents and Query Items as a String
        sendRequest(with: urlString)
        
    }
    ///The method to fetch the weather of a location using latitude and longitude coordinates. This method is called when the user presses the locationButton which triggered requestLocation(), thus triggering the didUpdateLocations() delegate method in which we now have access to the latitude and longtiude coordinates of the users device, therefore, be able to fetch the weather based on those coordinates.
    ///
    ///Use this method to fetch the weather of a particular location based on its latitude and longitude
    /// - parameter lat: Refers to the latitude, retrieved by didUpdateLocations().
    /// - parameter lon: Refers to the longitude, retrieved by didUpdateLocations().
    func fetchWeather(_ lat:CLLocationDegrees, _ lon: CLLocationDegrees){
        
        let latString = String(format: "%.2f", lat) //A reference to the latitude as a String.
        let lonString = String(format: "%.2f", lon) //A reference to the longitude as a String.
        
        guard var urlComponent = URLComponents(string: weatherURL) else { return } //Create URL
        urlComponent.scheme = "https"
        urlComponent.queryItems = [URLQueryItem(name: "lat", value: latString),
                                   URLQueryItem(name: "lon", value: lonString),
                                   URLQueryItem(name: "appid", value: apiKey),
                                   URLQueryItem(name: "units", value: unitOfMeasurement)] //Create queries, and add them to the URL.
 
        let urlString = urlComponent.url!.absoluteString //Reference to the URLComponents and Query Items as a String
        sendRequest(with: urlString)
        
    }
    
    /**
     The function that performs the networking, thus retrieving the weather data we desire from OpenWeather API as a Swift Object to be used in our app.
    
     Networking involves 4 steps:
     1. Create a URL object. (because this is how we will locate the resources we want from the open weather server)
     2. Create a URLSession. (because this is the object responsible for coordinating (like a browser) requests for our app).
     3. Create a task for the URLSession. (because requests are referred to as tasks, and the task we want to perform is to retrieve data from a server)
     4. Start the task. (because we want to execute this whole process - like pressing enter on the keyboard to search something on google)
     
     For further detail, we are making a GET call to a REST API but, this isn't the only way of networking. For example, solutions on Stack Overflow suggest using NSURLSession. Another example is that on freecodecamp, you create a URLSession.shared.dataTask which combines steps 2 and 3. Some even don't use closures.
     
     To understand API's, watch "APIs for Beginners 2023 - How to use an API" by freecodecamp on YouTube. It explains what API's are, why its important and how they work.
     
     - parameter urlString: Refers to the URL used to request the data we want from openweather API. 
    */
    func sendRequest(with urlString: String) {
        
        ///Step 1 of networking: Create a URL object.
        guard let url = URL(string: urlString) else { return }
        
        ///Step 2 of networking: Create a URLSession.
        let session = URLSession(configuration: .default)
        
        /**
        Step 3 of networking: Create a task for the URLSession.
        
        Inside the closure is where we will have access to the data we were requesting from OpenWeather, via the data parameter of the closure. This closure is also a completion handler, which means it is not called immediately, instead, it waits until something has finished (in our case, that is to retrieve the data from OpenWeather, which could take time due to your internet connection) and then, the completion handler is called. Once the completion handler is called, only then do we have access to the data we were requesting.
        
        Great! Now we have our data, but the next problem is that our data is in a JSON format (A format for transferring data across the web). In order to use the data in our app, we must convert this JSON format into a Swift Object. This process is called "parsing JSON." Therefore, using the data object, we shall parse this (JSON) data using the JSONDecoder object. (More details on the implementation in parseJSON(weatherData:) function)
         
        Once we have successfully parsed the JSON data and stored it as a Swift Object (namely the Weather Model), we will use the data in this model to change the UI of our app.
         
         Just in case there was an error that occured, we shall capture that error and pass it to the WeatherManagerDelegate. Additionally, if there was a non-acceptable HTTP response code (values that aren't in the acceptableCodes array), we shall pass this information to the WeatherManagerDelegate too.
        */
        let task = session.dataTask(with: url) { data, response, error in //Perform the task using the URL we created from step 1, and execute the completion handler.
            
            if let safeError = error {
                delegate?.didFailWithError(self, safeError)
                return
            }
            
            let acceptableCodes = [200, 201, 202, 203, 304]
            
            ///Helps to prevent runtime errors by ensuring the status codes are acceptable. We downcase the response as a HTTPURLResponse because we are using the https scheme in our request.
            guard let httpResponse = response as? HTTPURLResponse, acceptableCodes.contains(httpResponse.statusCode) else {
                
                delegate?.didRecieveErrorWithResponse(self, response!)
                return
            }
            
            if let safeData = data {
                if let weather = parseJSON(safeData) { //At this point, we should have the JSON as a Swift Object.
                    
                    ///Now, what do we want to do with the weather Swift Object? Well...
                    
                    ///Send this weather object back to the WeatherViewController so we can use the data there to change the UI accordingly!
                    
                    ///One method is to initialise the WeatherViewController here, and call a function that takes the weather object as one of its parameters (after creating it in the WeatherViewController). The disadvantage of this method is that it's not reusable.
                    
                    ///Hence the secoond method, use the delegate design pattern! Also worth noting, since Swift 5.3, Closures can now implicity refer to self if self is an instance of a struct (or enum), therefore in this case, that's why we don't need to write self.delegate.
                    
                    delegate?.didUpdateWeather(self, weather)
                    
                }
            }
            
        }
        
        ///Step 4 of networking: Start the task.
        task.resume()
        
    }
    
    /**
     The function to parse the JSON formatted data retrieved from openweatherapi.
     
     In order to successfully parse JSON formatted data, we must:
     1. Inform our complier of how the data is structured. (Create a struct for that data natively, and it must conform to the decodable protocol)
     2. Create JSON decoder object.
     3. Use decode method. Note that the first parmeter requires the type of the data itself, not the name of the type. The second parameter is the data we want to encode.
     4. decode can throw, which means we must mark it with a try keyword, and a do/catch block. Also it returns, so store a variable to this result. (Also, try to print out the decoded data to the console to test if the data is accurate and if the code works so far).
     5. Now that we have decoded the JSON data, we should store this data in a WeatherModel, so that we can put the data in our UI.
     6. Return the weatherModel object to where we parsed the JSON, i.e the URLSession task.
     
     - parameter weatherData: Refers to the data being retrieved by openweather in its JSON form. Later in this method, we convert this JSON into a Swift Object using the JSONDecoder object.
     */
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData) //Decoding the JSON file from OpenWeather to a Swift object.
            
            //All the data we want from the decodedData is as follows
            
            let id = decodedData.weather[0].id //Reference to the 'id' data from the JSON response. (To change the weather icon according to the weather condition)
            let temp = decodedData.main.temp //Reference to the 'temp' data from the JSON response. (To display the temperature)
            let name = decodedData.name //Reference to the 'name' data from the JSON response. (To display the city name)
            
            let weather = WeatherModel(temperature: temp, cityName: name, conditionID: id)
            
            //print(weather.temperatureString) //To test if we are getting the data as a Swift Object, and not in the JSON format.
            
            //Now that we have the weather data as a Swift Object, return it back to the URLSesion task.
            //The return type is optional because we want to return a nil object if any errors occur, therefore in order for a value to hold either a nil or a stored value, we must use optionals.
            
            return weather
            
        } catch {
            delegate?.didFailWithError(self, error)
            return nil //Since we don't want to return any objects, we should return nil. Therefore the output of this function must be set as an optional.
        }
    }
    
    
    
}
