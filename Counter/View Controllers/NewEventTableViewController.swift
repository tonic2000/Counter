//
//  NewEventTableVC.swift
//  Counter
//
//  Created by Nick Nguyen on 2/3/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

private let dateFormatter = Utilities.createDateFormatter(format: "E, d MMM yyyy")

class NewEventTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    static let  shared = NewEventTableViewController()
    var event: Event?
    var eventController : EventController?


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

    func textViewDidChange(_ textView: UITextView) {
        saveButton.isEnabled = textView.hasText
    }


    func textViewDidEndEditing(_ textView: UITextView) {
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconTextView.textContainer.maximumNumberOfLines = 1
        updateView()
        iconTextView.delegate = self

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
        guard let event = event else {
            title = "Add new event"
            return }

        title = event.name
        eventNameTextField.text = event.name
        letterTextView.text = event.letterContent
        iconTextView.text = event.emoji
        datePicker.date = event.date
    }


    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @IBAction func switchTapped(_ sender: UISwitch) {

        dateFormatter.dateFormat = sender.isOn ?  "E, d MMM yyyy HH:mm:ss" : "E, d MMM yyyy"
        datePicker.datePickerMode = sender.isOn ?  .time : .date
    }

    @IBAction func pickerChange(_ sender: UIDatePicker) {
        dateLabel.text = dateFormatter.string(from: sender.date)
    }

    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let name = eventNameTextField.text else { return }
        guard let emoji = iconTextView.text else { return }
        guard let content = letterTextView.text else { return }
        let pickedDate = datePicker.date
        let daysLeft = pickedDate.timeIntervalSinceNow

        print(daysLeft)

        if let event = event  {
            eventController?.update(event: event, name: name, content: content, date: pickedDate, emoji: emoji, daysLeft: daysLeft)

        } else {
            eventController?.createEvent(name: name, emoji: emoji, date: pickedDate, content: content, daysLeft: daysLeft)
        }


        //MARK:-  Push notification
        navigationController?.popViewController(animated: true)
        setNotification()
    }

    private func setNotification() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Today is \(eventNameTextField.text!)."
        content.body = "Message from the future: \(letterTextView.text ?? "Have a good day!")"
        content.sound = .defaultCritical

        let interval = datePicker.date.timeIntervalSinceNow //

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: abs(interval) , repeats: false)

        let reguest = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)



        center.add (reguest) { (error) in
            if error != nil {
                print("Error: \(error?.localizedDescription ?? "")")
            }
        }
    }
}

extension NewEventTableViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 40
    }

}
extension NewEventTableViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        var range = false 

        switch textView {
            case letterTextView:
                range = numberOfChars < 100
            case iconTextView:
                range = numberOfChars < 2   // 1 Icon max
            default:
                break
        }
        return range
    }
}
