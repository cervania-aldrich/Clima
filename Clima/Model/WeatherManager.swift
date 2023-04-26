import Foundation

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather"
    let apiKey = "a210b6f91c665d2db9eb566589c6c2aa"
    let unitOfMeasurement = "metric"
    
    func fetchWeather(_ cityName:String){
        
        //URLComponents already contains the proper percent encoding. Using this object results in more safe code for networking.
        
        guard var urlString = URLComponents(string: weatherURL) else { return } //Create URL
        urlString.scheme = "https"
        
        urlString.queryItems = [URLQueryItem(name: "q", value: cityName),
                                URLQueryItem(name: "appid", value: apiKey),
                                URLQueryItem(name: "units", value: unitOfMeasurement)] //Create queries, and add them to the URL.
        
        //print(urlString.url!.absoluteString) //Test I'm getting the corrent string
        
    }
    
    
    
}
