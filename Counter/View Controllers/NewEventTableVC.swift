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
    formatter.dateFormat = "E, d MMM yyyy HH:mm:ss "
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
              
              delegate?.didReceivedNewEvent(name: name, emoji: emoji, content: content, date: pickedDate, dayleft: daysLeft)
              
             navigationController?.popViewController(animated: true)
              
    }
    
    
    
}
extension Date {
    static func differ(lhs:Date,rhs:Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
