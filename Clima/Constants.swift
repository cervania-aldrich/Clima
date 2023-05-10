///Refers to all the constants used in the app.
struct Constants {
    
    static let locationPlaceholder = "Please enter a city name"
    
    struct Url {
        static let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&units=metric&"
        static let apiKey = "a210b6f91c665d2db9eb566589c6c2aa" //Please insert your API key from OpenWeather API here.U
        static let scheme = "https"
        static let metric = "metric"
        
        struct Query {
            static let cityName = "q"
            static let metric = "metric"
            static let apiID = "appid"
            static let units = "units"
            static let latitude = "lat"
            static let longitude = "lon"
        }
    }
    
    struct Conditions {
        static let cloudBolt = "cloud.bolt"
        static let cloudDrizzle = "cloud.drizzle"
        static let cloudRain = "cloud.rain"
        static let cloudSnow = "cloud.snow"
        static let cloudFog = "cloud.fog"
        static let sun = "sun.max"
        static let cloud = "cloud"
        static let tornado = "tornado"
        static let sunHaze = "sun.haze"
        static let sunDust = "sun.dust"
        static let smoke = "smoke"
        
    }

}
