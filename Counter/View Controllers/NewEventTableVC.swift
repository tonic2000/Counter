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
private var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "E, d MMM yyyy  "
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()

class NewEventTableVC: UITableViewController , UITextFieldDelegate, UITextViewDelegate {

    
    var event: Event?
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
 
    override func viewDidLoad() {
        super.viewDidLoad()
        eventNameTextField.becomeFirstResponder()
        eventNameTextField.delegate = self
        letterTextView.delegate = self
        timeSwitch.isOn = false
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
               
             delegate?.didReceivedNewEvent(name: name, emoji: emoji, content: content, date: pickedDate, dayleft: (daysLeft / 86400) )
              //MARK:-  Push notification
             navigationController?.popViewController(animated: true)
              setNotification()
    }
    
    
    
    
    func setNotification() {
           let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Hi there, how is it going?."
        content.body = "Here is your message from the future: \(letterTextView.text ?? "Have a good day!")"
        content.sound = .defaultCritical
        
        let interval = datePicker.date.timeIntervalSince(Date()) // 
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval , repeats: false)
        let reguest = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
           
          
           
           center.add (reguest) { (error) in
               if error != nil {
                   print("Error: \(error?.localizedDescription ?? "")")
               }
           }
           
           
       }
    

}
extension Date {
    static func differ(lhs:Date,rhs:Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
