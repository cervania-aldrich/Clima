import Foundation

///The requirements that the conforming type must implement. Here we have function named didUpdateWeather. Therefore, the conforming type must implement this method, such that the delegate creates the function and the WeatherManager calls the function.
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, _ weather:WeatherModel)
    func didFailWithError(_ weatherManager:WeatherManager, _ error: Error)
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
        
        let urlString = urlComponent.url!.absoluteString
        
        sendRequest(with: urlString)
        
    }
    
    /**
     The function that performs the networking.
    
     Networking involves 4 steps:
     1. Create a URL object.
     2. Create a URLSession.
     3. Create a task for the URLSession.
     4. Start the task.
    */
    func sendRequest(with urlString: String) {
        
        //Create a URL object
        guard let url = URL(string: urlString) else { return }
        
        //Create a URLSession.
        let session = URLSession(configuration: .default)
        
        //Create a task for the URLSession.
        let task = session.dataTask(with: url) { data, response, error in
            
            if let safeError = error {
                delegate?.didFailWithError(self, safeError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response!)")
                return
            }
            
            if let safeData = data {
                if let weather = parseJSON(safeData) { //At this point, we should have the JSON as a Swift Object.
                    
                    //Now, what do we want to do with the weather Swift Object? Well...
                    
                    //Send this weather object back to the WeatherViewController so we can use the data there to change the UI accordingly!
                    
                    //One method is to initialise the WeatherViewController here, and call a function that takes the weather object as one of its parameters (after creating it in the WeatherViewController). The disadvantage of this method is that it's not reusable.
                    
                    //Hence the secoond method, use the delegate design pattern! Also worth noting, since Swift 5.3, Closures can now implicity refer to self if self is an instance of a struct (or enum), therefore in this case, that's why we don't need to write self.delegate.
                    
                    delegate?.didUpdateWeather(self, weather)
                    
                    
                }
            }
            
        }
        
        //Start the task.
        task.resume()
        
    }
    
    /**
     The function to parse the JSON formatted data retrieved from openweatherapi.
     
     In order to successfully parse JSON formatted data, we must:
     1. Inform our complier of how the data is structured. (Create a struct for that data natvely)
     2. Create JSON decoder object.
     3. Use decode method. Note that the first parmeter requires the type of the data itself, not the name of the type. The second parameter is the data we want to encode.
     4. decode can throw, which means we must mark it with a try keyword, and a do/catch block. Also it returns, so store a variable to this result. (Also, try to print out the decoded data to the console to test if the data is accurate and if the code works so far).
     5. Now that we have decoded the JSON data, we should store this data in a WeatherModel, so that we can put the data in our UI.
     6. Return the weatherModel object to where we parsed the JSON, i.e the URLSession task.
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
            
            //print(weather.temperatureString)
            
            //Now that we have the weather data as a Swift Object, return it back to the URLSesion task.
            //The return type is optional because we want to return a nil object if any errors occur, therefore in order for a value to hold either a nil or a stored value, we must use optionals.
            
            return weather
            
        } catch {
            delegate?.didFailWithError(self, error)
            return nil //Since we don't want to return any objects, we should return nil. Therefore the output of this function must be set as an optional.
        }
    }
    
    
    
}
