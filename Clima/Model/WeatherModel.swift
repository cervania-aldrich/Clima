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
            return Constants.Conditions.cloudBolt
            
        case 300...321:
            return Constants.Conditions.cloudBolt
            
        case 500...531, 771:
            return Constants.Conditions.cloudRain
            
        case 600...622:
            return Constants.Conditions.cloudSnow
            
        case 701, 741...751:
            return Constants.Conditions.cloudFog
        
        case 711:
            return Constants.Conditions.smoke
            
        case 721:
            return Constants.Conditions.sunHaze
            
        case 731, 761:
            return Constants.Conditions.sunDust
            
        case 781:
            return Constants.Conditions.tornado
            
        case 801...804:
            return Constants.Conditions.cloud
            
        default:
            return Constants.Conditions.sun
        }
        
    }
    
}
