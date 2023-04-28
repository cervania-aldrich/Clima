import Foundation

struct WeatherManager {
    
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather"
    let apiKey = "a210b6f91c665d2db9eb566589c6c2aa"
    let unitOfMeasurement = "metric"
    
    func fetchWeather(_ cityName:String){
        
        //URLComponents already contains the proper percent encoding. Using this object results in more safe code for networking.
        
        guard var urlComponent = URLComponents(string: weatherURL) else { return } //Create URL
        urlComponent.scheme = "https"
        urlComponent.queryItems = [URLQueryItem(name: "q", value: cityName),
                                URLQueryItem(name: "appid", value: apiKey),
                                URLQueryItem(name: "units", value: unitOfMeasurement)] //Create queries, and add them to the URL.
        
        let urlString = urlComponent.url!.absoluteString
        
        sendRequest(urlString)
        
    }
    
    /**
     The function that performs the networking.
    
     Networking involves 4 steps:
     1. Create a URL object.
     2. Create a URLSession.
     3. Create a task for the URLSession.
     4. Start the task.
    */
    func sendRequest(_ urlString: String) {
        
        //Create a URL object
        guard let url = URL(string: urlString) else { return }
        
        //Create a URLSession.
        let session = URLSession(configuration: .default)
        
        //Create a task for the URLSession.
        let task = session.dataTask(with: url) { data, response, error in
            
            if let safeError = error {
                print(safeError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response!)")
                return
            }
            
            if let safeData = data {
                parseJSON(safeData)
                
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
     */
    
    func parseJSON(_ weatherData: Data){
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            //All the data we want from the decodedData is as follows
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(temperature: temp, cityName: name, conditionID: id)
            
            print(weather.temperatureString)
            
        } catch {
            print(error)
        }
    }
    
    
    
}
