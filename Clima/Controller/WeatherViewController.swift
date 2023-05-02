import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {

    @IBOutlet weak var conditionImageView: UIImageView! //Images come from SF Symbols
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)) //Create a tap gesture
        view.addGestureRecognizer(tap) //Add the tap gesture to the screen
        
        searchTextField.delegate = self //Assign the current class as the delegate
        weatherManager.delegate = self
        
    }
    
    ///A function that defines the behaviour to dismiss the keyboard, using a method.
    @objc func dismissKeyboard (){
        view.endEditing(true)
    }
    
    ///A function that defines the behaviour when the search button is pressed. That desired behaviour is to search for the weather based on the users input.
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) //Dismiss the keyboard
    }
    
    ///A function that defines the behaviour when the user has pressed the return key on the iPhone keyboard (Pressing enter on the keyboard).
    ///We return true, because we want to process the search key, and run this function. Which means, this behaviour is analogous to having an IBAction to that return button.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) //Dismiss the keyboard
        return true
    }
    
    ///A function that defines the behaviour the the textField on screen are done with editing. (Called using .endEditing method).
    ///This is the ideal place to search for the weather of a city.
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //Search the weather for the city entered in the textField.
        let city = searchTextField.text ?? "London"
        
        weatherManager.fetchWeather(city)
        
        searchTextField.text = "" //Clears the textField so we can enter a new search term.
    }
    
    ///A function that defines the behaviour when the user tries to deselect the textField.
    ///
    ///This function is useful for validating what the user has typed, so we don't just trap the user in editing mode.
    ///Note that this function is called by the UITextField class, not this ViewController (similar to the other textField delegate methods).
    ///Since we only have one textField in the app, then it is this textField (searchTextField) that calls this method. But we could have had more textField's triggering this method.
    ///This is analogous to linking multiple buttons to a single IBAction. Multiple textField's can be linked to the one textField class.
    ///Like the sender parameter of an IBAction, the textField parameter can tell which textField is which (as long as those textField's sets its delegate to the current class: i.e. conforming to UITextFieldDelegate).
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
    
    func didUpdateWeather(_ weather: WeatherModel) {
        print(weather.temperatureString)
    }
    
    
}

