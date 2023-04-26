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
            
            if error != nil {
                print(error!)
                return
            }
            
            if let safeData = data {
                let dataString = String(data: safeData, encoding: .utf8)
                print(dataString!)
            }
            
            
            
        }
        
        //Start the task.
        task.resume()
        
    }
    
    
    
}
