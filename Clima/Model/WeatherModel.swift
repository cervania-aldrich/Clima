///This structs uses the response from the WeatherData (the struct responsible for turning JSON into a Swift Object) and further formats that data so that it is ready to be displayed on the view controller.
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
            
        case 500...531, 771:
            return "cloud.rain"
            
        case 600...622:
            return "cloud.snow"
            
        case 701, 741...751:
            return "cloud.fog"
        
        case 711:
            return "smoke"
            
        case 721:
            return "sun.haze"
            
        case 731, 761:
            return "sun.dust"
            
        case 781:
            return "tornado"
            
        case 801...804:
            return "cloud"
            
        default:
            return "sun.max"
        }
        
    }
    
    
}
