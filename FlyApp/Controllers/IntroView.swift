//
//  IntroView
//  FlyApp
//
//  Created by Jacob Goldfarb on 2018-01-15.
//  Copyright © 2018 JacobGoldfarb. All rights reserved.
//TODO NEXT TIME:
//Pass values wtih user defaults
//IGA = itnierary generation algorithm

import UIKit
import BWWalkthrough
import SearchTextField

class IntroView: UIViewController {
    
    //MARK: Preset Sliders & Labels declerations
    @IBOutlet weak var budgetSlider: UISlider!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var activitySlider: UISlider!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var nightlifeSlider: UISlider!
    @IBOutlet weak var nightlifeLabel: UILabel!
    @IBOutlet weak var cultureSlider: UISlider!
    @IBOutlet weak var cultureLabel: UILabel!
    @IBOutlet weak var parksSlider: UISlider!
    @IBOutlet weak var parksLabel: UILabel!
    @IBOutlet weak var historySlider: UISlider!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var shoppingSlider: UISlider!
    @IBOutlet weak var shoppingLabel: UILabel!
    
    
    @IBOutlet var destinationField: SearchTextField!
    @IBOutlet weak var firstDateField: UITextField!
    @IBOutlet weak var lastDateField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    enum generationErrors: Error{
        case blankDestination
        case missingDate
    }
    ///Initialize the user defaults with the default values for each parameter.
    override func loadView() {
        super.loadView()
        
        let currentDate = Date(timeIntervalSinceNow: 0)
        UserDefaults.standard.set(2, forKey: "budget")
        UserDefaults.standard.set(3, forKey: "activity")
        UserDefaults.standard.set(3, forKey: "nightlife")
        UserDefaults.standard.set(2, forKey: "parks")
        UserDefaults.standard.set(2, forKey: "culture")
        UserDefaults.standard.set(2, forKey: "shopping")
        UserDefaults.standard.set(2, forKey: "history")
        
        UserDefaults.standard.set("", forKey: "destination")

        UserDefaults.standard.set(currentDate.midnight, forKey: "firstDate")
        UserDefaults.standard.set(currentDate.midnight.addingTimeInterval(day_), forKey: "secondDate")
    }
    
    //Sets all the min, max, and default values for the sliders.
    override func viewDidLoad(){
        
        super.viewDidLoad()
        printInfo()
        
        createToolbarForDatePicker()
        setSliderDetails()
        setTextFieldDetails()

        //Enables tapping to dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchedScreen))
        view.addGestureRecognizer(tap)
        
        //If the login button has loaded,format it appropriately.
        if(loginButton?.layer.cornerRadius != nil){
            loginButton.layer.cornerRadius = 15
        }
    }
    //Dismisses keyboard and updates text input values.
    func touchedScreen() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        if(destinationField != nil){
            UserDefaults.standard.set(destinationField.text!, forKey: "destination")
        }
    }
    
    func setSliderDetails(){
        budgetSlider?.minimumValue = 0
        budgetSlider?.maximumValue = 4
        budgetSlider?.value = 2
        
        activitySlider?.minimumValue = 0
        activitySlider?.maximumValue = 4
        activitySlider?.value = 2
        
        nightlifeSlider?.minimumValue = 0
        nightlifeSlider?.maximumValue = 4
        nightlifeSlider?.value = 2
        
        cultureSlider?.minimumValue = 0
        cultureSlider?.maximumValue = 4
        cultureSlider?.value = 2
        
        parksSlider?.minimumValue = 0
        parksSlider?.maximumValue = 4
        parksSlider?.value = 2
        
        historySlider?.minimumValue = 0
        historySlider?.maximumValue = 4
        historySlider?.value = 2
        
        shoppingSlider?.minimumValue = 0
        shoppingSlider?.maximumValue = 4
        shoppingSlider?.value = 2
    }
    func setTextFieldDetails(){
        destinationField?.filterStrings(["Chicago","Toronto","Vancouver","New York","Las Vegas","Los Angeles","Honolulu","London","Jerusalem","Tel Aviv","Paris","Amsterdam", "Tokyo", "Cancun", "Halifax", "Montreal", "Vienna", "Rome", "Naples", "Haifa", "Eilat", "Oslo", "Sydney", "Budapest", "Moscow"])
        destinationField?.maxNumberOfResults = 10;
        destinationField?.theme.font = UIFont.systemFont(ofSize: 16)
        destinationField?.highlightAttributes = [NSBackgroundColorAttributeName: UIColor.yellow, NSFontAttributeName:UIFont.boldSystemFont(ofSize: 16)]
        
        destinationField?.delegate = self
        destinationField?.tag = 0
        destinationField?.autocapitalizationType = .sentences
        destinationField?.returnKeyType = .next
        
        firstDateField?.delegate = self
        firstDateField?.tag = 1
        
        lastDateField?.delegate = self
        lastDateField?.tag = 2
    }
    func createToolbarForDatePicker(){
        //Create and size the toolbar.
        let toolBar = UIToolbar(frame: CGRect(x:0,y:self.view.frame.size.height/6, width:self.view.frame.size.width,height:40.0))
        
        //Format and placethe toolbar.
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.default
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.gray
        
        let toolBar2 = UIToolbar(frame: CGRect(x:0,y:self.view.frame.size.height/6, width:self.view.frame.size.width,height:40.0))
        
        //Format and placethe toolbar.
        toolBar2.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar2.barStyle = UIBarStyle.default
        toolBar2.tintColor = UIColor.white
        toolBar2.backgroundColor = UIColor.gray
        
        let nextBarBtn = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextTextfield))
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(touchedScreen))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.white
        label.text = "Select the first trip date"
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([flexSpace,textBtn,flexSpace,nextBarBtn], animated: true)
        toolBar2.setItems([flexSpace,textBtn,flexSpace,okBarBtn], animated: true)
        
        firstDateField?.inputAccessoryView = toolBar
        lastDateField?.inputAccessoryView = toolBar2
    }
    func nextTextfield(){
        
        let nextTag:Int = firstDateField.tag + 1
        
        // Try to find next responder
        if let nextF = firstDateField.superview?.viewWithTag(nextTag){
            let nextField = nextF as! UITextField
            nextField.becomeFirstResponder()
        }
        else {
            // Not found, so remove keyboard.
            firstDateField.resignFirstResponder()
        }
    }
    
    @IBAction func beganEditingDate1(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        let defaultDate = UserDefaults.standard.object(forKey: "firstDate") as! Date
        firstDateField.text = dateFormatter.string(from: defaultDate)

        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.minimumDate = Date(timeIntervalSinceNow: 0)
        datePickerView.date = defaultDate
        datePickerView.maximumDate = Date(timeIntervalSinceNow: year_*2)
        firstDateField.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    @IBAction func beganEditingDate2(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        let defaultDate = UserDefaults.standard.object(forKey: "secondDate") as! Date
        lastDateField.text = dateFormatter.string(from: defaultDate)
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        datePickerView.minimumDate = UserDefaults.standard.value(forKey: "firstDate") as? Date
        datePickerView.date = defaultDate
        datePickerView.maximumDate = Date(timeIntervalSinceNow: year_*2)
        
        lastDateField.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged2), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        firstDateField.text = dateFormatter.string(from: sender.date)
        UserDefaults.standard.set(sender.date.midnight, forKey: "firstDate")
        print("Date: \(sender.date.midnight)")
        print("Date: \(sender.date.midnight.description(with: .current))")

    }
    func datePickerValueChanged2(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        //TODO check if firstDateField is unwrapped to prevent crashing if user edits this field first.
        
        lastDateField.text = dateFormatter.string(from: sender.date)
        
        UserDefaults.standard.set(sender.date.midnight, forKey: "secondDate")
        print("Date: \(sender.date.midnight.description(with: .current))")
    }
    
    @IBAction func pushedLogin(_ sender: Any) {
        
        let alert = UIAlertController(title: "Alert", message: "Error found.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        
        do {
            try generateTrip()
            print("Successfully called generateTrip.")
            
        } catch generationErrors.blankDestination {
            
            alert.message = "Please enter a destination."
            self.present(alert, animated: true, completion: nil)
            
        } catch generationErrors.missingDate {
            alert.message = "Please enter both trip dates."
            self.present(alert, animated: true, completion: nil)
        } catch {
            alert.message = "Unexpected error."
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    func generateTrip() throws{
        //TODO: Handle if all parameters are zero.
        //TODO: Handle userdefaults for multiple trips.
        //Also, add uibarbutton that allows the user to input the same day
        
        let firstDate = UserDefaults.standard.value(forKey: "firstDate") as? Date
        let secondDate = UserDefaults.standard.value(forKey: "secondDate") as? Date
        
        let firstDateStr = firstDate?.toString(dateFormat: "dd-MM-yy")
        let secondDateStr = secondDate?.toString(dateFormat: "dd-MM-yy")

        let destination = UserDefaults.standard.string(forKey: "destination")
        
        guard destination != nil && destination != "" else {
            throw generationErrors.blankDestination
        }
        guard firstDateStr != nil && firstDateStr != "" else {
            throw generationErrors.missingDate
        }
        guard secondDateStr != nil && secondDateStr != "" else {
            throw generationErrors.missingDate
        }
        
        printInfo()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "grabData"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func printInfo(){
        print("------------Parmater Info-----------------")
        print("Activity level: \(UserDefaults.standard.integer(forKey: "activity"))")
        print("Budget: \(UserDefaults.standard.integer(forKey: "budget"))")
        print("Night life level: \(UserDefaults.standard.integer(forKey: "nightlife"))")
        print("Culture level: \(UserDefaults.standard.integer(forKey: "culture"))")
        print("Parks level: \(UserDefaults.standard.integer(forKey: "parks"))")
        print("History level: \(UserDefaults.standard.integer(forKey: "history"))")
        print("shopping level: \(UserDefaults.standard.integer(forKey: "shopping"))")
        print("Destination:\(UserDefaults.standard.string(forKey: "destination") ?? "Missing destination")" )
        print("First Date:\(UserDefaults.standard.value(forKey: "firstDate") ?? "Missing date 1")" )
        print("Second Date:\(UserDefaults.standard.value(forKey: "secondDate") ?? "Missing date 2")")
        print("-------------------------------------------")
    }
}
//MARK: UITextFieldDelegate
extension IntroView: UITextFieldDelegate{
    //Function to tab through text boxes.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        let nextTag:Int = textField.tag + 1
        
        // Try to find next responder
        if let nextF = textField.superview?.viewWithTag(nextTag){
            let nextField = nextF as! UITextField
            nextField.becomeFirstResponder()
        }
        else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        
        UserDefaults.standard.set(destinationField.text, forKey: "destination")
        
        return false
    }
}
//MARK: Slider Adjustments
extension IntroView{
    @IBAction func changedBudget(_ sender: Any) {
        switch budgetSlider.value {
        case 0..<1:
            budgetLabel.text = "$"
        case 1..<2:
            budgetLabel.text = "$$"
        case 2..<3:
            budgetLabel.text = "$$$"
        case 3...4:
            budgetLabel.text = "$$$$"
            
        default:
            budgetLabel.text = "Budget"
        }
        UserDefaults.standard.set(budgetSlider.value, forKey: "budget")
    }
    
    @IBAction func changedActivityLevel(_ sender: Any) {
        
        switch activitySlider.value {
        case 0..<1:
            activityLabel.text = "Veggie"
        case 1..<2:
            activityLabel.text = "Slouch"
        case 2..<3:
            activityLabel.text = "Takin' it easy"
        case 3...4:
            activityLabel.text = "Hustler" //Busy Beaver?
        default:
            activityLabel.text = "Activity Level"
        }
        UserDefaults.standard.set(activitySlider.value, forKey: "activity")
    }
    @IBAction func changedNightLife(_ sender: Any) {
        switch nightlifeSlider.value {
        case 0..<1:
            nightlifeLabel.text = "0"
        case 1..<2:
            nightlifeLabel.text = "Lightweight"
        case 2..<3:
            nightlifeLabel.text = "Disco Stu"
        case 3...4:
            nightlifeLabel.text = "Party Animal"
        default:
            nightlifeLabel.text = "Night Life"
        }
        UserDefaults.standard.set(nightlifeSlider.value, forKey: "nightlife")
        
    }
    @IBAction func changedCulture(_ sender: Any) {
        switch cultureSlider.value {
        case 0..<1:
            cultureLabel.text = "0-1"
        case 1..<2:
            cultureLabel.text = "1-2"
        case 2..<3:
            cultureLabel.text = "2-3"
        case 3...4:
            cultureLabel.text = "3-4"
        default:
            cultureLabel.text = "Festival Fanatic"
        }
        UserDefaults.standard.set(cultureSlider.value, forKey: "culture")
        
    }
    @IBAction func changedParks(_ sender: Any) {
        
        UserDefaults.standard.set(parksSlider.value, forKey: "parks")
    }
    
    @IBAction func changedshopping(_ sender: Any) {
        
        UserDefaults.standard.set(shoppingSlider.value, forKey: "shopping")
    }
    @IBAction func changedHistory(_ sender: Any) {
        
        UserDefaults.standard.set(historySlider.value, forKey: "history")
    }
}
