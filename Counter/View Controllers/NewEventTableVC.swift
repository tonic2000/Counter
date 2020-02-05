//
//  NewEventTableVC.swift
//  Counter
//
//  Created by Nick Nguyen on 2/3/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit


protocol NewEventTableViewControllerDelegate : AnyObject {
    func didReceivedNewEvent(name:String,emoji:String,content:String,date:Date,dayleft: Double)
}


private let dateFormatter = Helper.createDateFormatter(format: "E, d MMM yyyy")

class NewEventTableVC: UITableViewController , UITextFieldDelegate, UITextViewDelegate , UIGestureRecognizerDelegate {

    
    var event: Event?
//        didSet {
//            updateView()
//        }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 40
    }
   func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       //300 chars restriction
       return textView.text.count + (text.count - range.length) <= 0
   }

  
    var eventController : EventController?
     
    weak var delegate: NewEventTableViewControllerDelegate?
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var iconTextView: UITextView!
    @IBOutlet weak var letterTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    
    @IBAction private func textFieldDidChanged(_ sender: UITextField) {
        saveButton.isEnabled = eventNameTextField.hasText
        
    }
  
    func textViewDidEndEditing(_ textView: UITextView) {
        view.endEditing(true)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        iconTextView.textContainer.maximumNumberOfLines = 1
          updateView()
        
        
        eventNameTextField.becomeFirstResponder()
        eventNameTextField.delegate = self
        letterTextView.delegate = self
        timeSwitch.isOn = false
        
        // Dismiss keyboard when tapped on screen
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    func updateView() {
        if let event = event {
            eventNameTextField.text = event.name
            letterTextView.text = event.letterContent
        }
        title = "Add New Event"
    }
    
    
   @objc func dismissKeyboard() {
           self.view.endEditing(true)
       }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        
        dateFormatter.dateFormat = sender.isOn ?  "E, d MMM yyyy HH:mm:ss" : "E, d MMM yyyy"
        
        if sender.isOn {
            datePicker.datePickerMode = .time
           
        } else {
            datePicker.datePickerMode = .date
        }
    }
    
    

    @IBAction func pickerChange(_ sender: UIDatePicker) {
        dateLabel.text = dateFormatter.string(from: sender.date)
    }

    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let name = eventNameTextField.text else { return }
              guard let emoji = iconTextView.text else { return }
              guard let content = letterTextView.text else { return }
              let pickedDate = datePicker.date
        
              let daysLeft = Date.differ(lhs: pickedDate, rhs: Date())
               
        if let event = event  {
            eventController?.update(event: event, name: name, content: content, date: pickedDate)
        }
//        } else {
//            eventController?.createEvent(name: name, emoji: emoji, date: pickedDate, content: content, daysLeft: daysLeft)
//        }
        
        
             delegate?.didReceivedNewEvent(name: name,
                                           emoji: emoji,
                                           content: content,
                                           date: pickedDate,
                                           dayleft: daysLeft)
              //MARK:-  Push notification
             navigationController?.popViewController(animated: true)
              setNotification()
    }
 
    private func setNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Hi there, how is it going?."
        content.body = "Here is your message from the future: \(letterTextView.text ?? "Have a good day!")"
        content.sound = .defaultCritical
        
        let interval = datePicker.date.timeIntervalSince(Date()) //
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: abs(interval) , repeats: false)
        
        let reguest = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        
        
        
        center.add (reguest) { (error) in
            if error != nil {
                print("Error: \(error?.localizedDescription ?? "")")
            }
        }
        
        
    }
    
    
}

