import UIKit
import CoreLocation // The framework used to obtain the geographic location and orientation of a device. (See docs for more information)

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView! //Images come from SF Symbols
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager() // The object that is responsible for all location services.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)) //Create a tap gesture
        view.addGestureRecognizer(tap) //Add the tap gesture to the screen
        
        searchTextField.delegate = self //Assign the current class as the delegate
        weatherManager.delegate = self
        locationManager.delegate = self //Delegate must be in place before you start any location services.
        
    }
    
    ///A function that defines the behaviour to dismiss the keyboard.
    @objc func dismissKeyboard (){
        view.endEditing(true)
    }
    
    ///The function where location services are launched.
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled(){ //Check if the device location services are enabled.
                self.locationManager.requestWhenInUseAuthorization() //Request access to location information when using the app.
                self.locationManager.requestLocation() //Triggers the didUpdateLocations delegate method.
            }
        }
    }
    
    
}

//MARK: - CLLocationManagerDelegate

//According to the apple docs, we must verify that location services are available before we start collecting location data. We do this by instantiating a CLLocationManager object in the class that will handle location updates, and assign the same class as the delegate to CLLocationManagerDelegate protocol. Afterwards, we must request authorization from the users as location data is sensitive personal information.

extension WeatherViewController: CLLocationManagerDelegate {
    
    /**
     Delegate method to check the app's current authorization status to see if a request is necessary.
     
     Note that this method is actually deprecrated, and it is the method used to support earlier versions of iOS. From iOS 14+, we should use the new delegate method called locationManagerDidChangeAuthorization. This method is shortly called after CLLocationManager is initialised.
     */
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        //Create a switch statement for the status value
        
        switch status {
            
        case .notDetermined: // Authorization not determined yet.
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .authorizedWhenInUse: // Location services are available.
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation = locations.last else { return }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        weatherManager.fetchWeather(lat,lon)
        
    }
    
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

