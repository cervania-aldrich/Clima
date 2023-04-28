/**The file contains the structure of the JSON formatted data.
 
 Instead of just having a dataString that prints the response straight from the server in a JSON format, we decode that data into our app so we can use it. Marking the struct with the Decodable protocol, means that the struct can decode itself from an external representation, i.e. the JSON representation.
 
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

