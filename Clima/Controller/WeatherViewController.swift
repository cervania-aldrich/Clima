import UIKit
///The framework used to obtain the geographic location and orientation of a device. Core Location collects data via onboard components such as Wi-Fi, GPS, Bluetooth, magnetometer, barometer, and cellular hardware. In addition to importing CoreLocation, we must provide a reason as to why our app needs the users location information in the info.plist using the "Privacy — Location When In Use Usage Description" key.
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView! //Images come from SF Symbols
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    
    ///The object reponsible for the logic of the app.
    var weatherManager = WeatherManager()
    
    ///The object that is responsible for all location services.
    ///
    ///Creating a CLLocationManager object, as well as making the WeatherViewController conform to the CLLocationManagerDelegate protocol, are the first steps of using Core Location. The next steps to configuring the app to use location services, is to request for authorization from the user and to define what type of location service you desire using the CLLocationManager object. We do this inside the locationButtonPressed().
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)) //Create a tap gesture
        view.addGestureRecognizer(tap) //Add the tap gesture to the screen
        
        searchTextField.delegate = self //Assign the current class as the delegate
        weatherManager.delegate = self
        locationManager.delegate = self //Delegate must be in place before you start any location services.
        
    }
    
    ///A function that defines the behaviour to dismiss the keyboard. This function is passed to the action parameter of UITapGestureRecognizer.
    @objc func dismissKeyboard (){
        view.endEditing(true)
    }

    /**
     The function where location services are launched, and it is where we request authorization from the user and define the location service we want to use. Before we do so, it is good to check if location services are enabled by the users device and although this step isn't mandatory, it is still good to check.
     
     The type of authorization we are requesting from the user is called "When in use" authorization, which means allowing access to location information when using the app
     
     The type of location service we are using is the "requestLocation()." Note there are other location services we could use (see "running the standard location service" topic in CLLocationManager), but requestLocation is what we need for this app because we are only requesting one location, unlike a GPS which is requesting for multiple locations. Now with how apple has designed the Core Location framework, we don't directly access the location information directly from CLLocationManager, instead we use the didUpdateLocations delegate method (from CLLocationManagerDelegate) that contains location object(s) inside of it, and then we can write some code to handle those location objects. See the didUpdateLocations() to see how we handled those location objects!
     */
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled(){ //Check if the device location services are enabled.
                self.locationManager.requestWhenInUseAuthorization() //Request access to location information when using the app.
                self.locationManager.requestLocation() //Triggers the associated delegate methods "didUpdateLocations" and "didFailWithError."
            }
        }
    }
    
    
}

//MARK: - CLLocationManagerDelegate

///We can't directly access the location information from CLLocationManager, instead, we use one of the methods in the CLLocationManagerDelegate protocol called "didUpdateLocations."
extension WeatherViewController: CLLocationManagerDelegate {
    
    /**
     This is a delegate method to check the app's current authorization status to see if a request is necessary. In the method, we are comparing the switch value with different cases, such as .notDetermined, .authorizedWhenInUse, .restricted and .denied.
     
     Note that this method is actually deprecrated, and it is the method used to support earlier versions of iOS. From iOS 14+, we should use the new delegate method called locationManagerDidChangeAuthorization. This method is shortly called after CLLocationManager is initialised.
     */
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        //Create a switch statement for the status value
        
        switch status {
            
        case .notDetermined:        // Authorization not determined yet.
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .authorizedWhenInUse:  // Location services are available.
            locationManager.requestLocation()
            break
            
        case .restricted, .denied:  // Location services currently unavailable.
            // restricted by e.g. parental controls. User can't enable Location Services
            // user denied your app access to Location Services, but can grant access from the settings
            break

        default:
            break
        }
    }
    
    /**
     This delegate method is associated with the requestLocation() method, and it is called at requestLocation(). This is where we directly have access to the location information. It's in the locations parameter!
     
     In the location object we have access to numerous properties, but the properties we want access to are the latitude and longitude properties. This is because in our API request, the URL requires a lat and lon query so that we can search for a particular city at those coordinates.
     
     - parameter locations: An array of location objects. The objects in the array are organized in the order in which they occurred. Therefore, the most recent location update is at the end of the array.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let mostRecentLocation = locations.last else { return }
        
        let lat = mostRecentLocation.coordinate.latitude
        let lon = mostRecentLocation.coordinate.longitude
        
        weatherManager.fetchWeather(lat,lon)
        
    }
    
    ///This delegate method is also associated with the requestLocation() method, and it must be implemented alongside didUpdateLocations(), as it says in the requestLocation() documentation.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error with location")
    }
    
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    ///A function that defines the behaviour when the search button is pressed. That desired behaviour is to search for the weather based on the users input.
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) //Dismiss the keyboard
    }
    
    /**
     A function that defines the behaviour when the user has pressed the return key on the iPhone keyboard (Pressing enter on the keyboard).
     
     We return true, because we want to process the search key, and run this function. Which means, this behaviour is analogous to having an IBAction to that return button.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) //Dismiss the keyboard
        return true
    }
    
    ///A function that defines the behaviour the the textField on screen are done with editing. (Called using .endEditing method). This is the ideal place to search for the weather of a city.
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //Search the weather for the city entered in the textField.
        let city = searchTextField.text ?? "London"
        
        weatherManager.fetchWeather(for: city)
        
        searchTextField.text = "" //Clears the textField so we can enter a new search term.
    }
    
    /**
     A function that defines the behaviour when the user tries to deselect the textField.
     
     This function is useful for validating what the user has typed, so we don't just trap the user in editing mode.
     
     Note that this function is called by the UITextField class, not this ViewController (similar to the other textField delegate methods). Since we only have one textField in the app, then it is this textField (searchTextField) that calls this method. But we could have had more textField's triggering this method.
     
     This is analogous to linking multiple buttons to a single IBAction. Multiple textField's can be linked to the one textField class.
     
     Like the sender parameter of an IBAction, the textField parameter can tell which textField is which (as long as those textField's sets its delegate to the current class: i.e. conforming to UITextFieldDelegate).
     */
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        //textField refers to any textField conforming to the UITextFieldDelegate in this class.
        //Also, we could have used searchTextField instead of textField, but this is a teaching tool to show and give us a better understanding of how this function is called.
        
        if textField.text != "" {
            return true //We want to endEditing when the textField as an input.
        } else {
            textField.placeholder = "Please enter a city name"
            return false //Keep the keyboard where it is until the user as entered a city name.
        }
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    /**
     This function comes from the WeatherManagerDelegate protocol, where in this conforming class we are providing the actual implemetation for the protocol requirements.
     
     We wrap the code that modifies the UI with an asynchronous dispatch call to the main thread, because currently the UI is being updated on the background and not the main thread where it's suppose to be due to the UI using information from a completion handler, where completion handlers are done in the background thread. XCode's main threader tool will also warn us of this error.
     
     - parameter weatherManager: The identity of the object that calls this delegate method. It is an Apple naming convention to include this first parameter in your delegate methods. This also makes any properties available to the method.
     - parameter weather: The object that has the information (response) from openweather api as a Swift Object, (after decoding the JSON)
     **/
    func didUpdateWeather(_ weatherManager:WeatherManager, _ weather: WeatherModel) {
        
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
        
    }
    
    func didFailWithError(_ weatherManager: WeatherManager, _ error: Error) {
        print(error)
    }
}

