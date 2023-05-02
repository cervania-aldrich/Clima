/**This struture assists the JSONDecoder to convert JSON into Swift Objects.
 
 Instead of just having a dataString that prints the response straight from the server in a JSON format, we decode that data into our app so we can use it. Marking the struct with the Decodable protocol, means that the struct can decode itself from an external representation, i.e. the JSON representation. The encodable protocol does the opposite, it allows how Swift objects to be encoded into a JSON. Also note that there is a type alias that combines the two protocols together called "Codable."
 
 **/
struct WeatherData : Decodable {
    
    let name:String
    let dt:Int
    let main:Main
    let weather:[Weather]

}

struct Main: Decodable {
    let temp:Double
}

struct Weather: Decodable {
    let description:String
    let id:Int
}

