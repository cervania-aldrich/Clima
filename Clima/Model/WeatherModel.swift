struct WeatherModel {
    
    let temperature:Double
    let cityName:String
    let conditionID:Int
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
            
        case 300...321:
            return "cloud.drizzle"
            
        case 500...531:
            return "cloud.rain"
            
        case 600...622:
            return "cloud.snow"
            
        case 700...781:
            return "cloud.fog"
            
        case 801...804:
            return "cloud"
            
        default:
            return "sun.max"
        }
        
    }
    
    
}
