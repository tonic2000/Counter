//
//  EventCell.swift
//  Counter
//
//  Created by Nick Nguyen on 2/3/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import Foundation

protocol EventCellDelegate: AnyObject {
    func updateTimer2()
}


class EventCell: UITableViewCell   {

    var countdownTimer :Timer?
    let dateFormatter  = Helper.createDateFormatter(format:" E, d MMM yyyy")
    
    weak var delegate : EventCellDelegate?
    
    var countdown = EventDetailVC()
    
    private  func updateViews() {
        guard let event = event else { return }
        startTimer()
        eventNameLabel.text = event.name
        emojiLabel.text = event.emoji
        
        eventDateLabel.text = dateFormatter.string(from: event.date)
        eventDaysLeft.text = event.daysLeft > 0.0 ? updateTimer() : "☑️"
        eventDaysLeft.backgroundColor = UIColor(displayP3Red: 176/255, green: 196/255, blue: 222/255, alpha: 1.0)
        if event.daysLeft == 0.0 {
             countdown.countdownTimer?.invalidate()
            countdownTimer?.invalidate()
         
        }
    }
    
    
   private func startTimer() {
    
    countdownTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                             target: self,
                                             selector: #selector(updateTimer),
                                             userInfo: nil,
                                             repeats: true)
   
    }
    
    @objc func updateTimer() -> String  {
        guard let futureDate = event?.date else { return ""}
        guard let daysLeft = event?.daysLeft else { return  ""}
        let currentDate = Date()
        let calendar = Calendar.current
        let diffDateComponents = calendar.dateComponents([.day,.hour,.minute,.second], from: currentDate,to: futureDate)

        switch Int(daysLeft) {
            
            // MARK: - TODO
        case  ...0 :
            eventDaysLeft.text = "☑️"
           
            countdownTimer = nil
            countdownTimer?.invalidate()

        case 0...59:
            eventDaysLeft.text = "\(diffDateComponents.second!) seconds left."
        case 60...3599:
            eventDaysLeft.text = "\(diffDateComponents.minute!) minutes left."
        case 3600...86399:
            eventDaysLeft.text = "\(diffDateComponents.hour!) hours, \(diffDateComponents.minute!) mins left."
        case let x where x >= 86400 :
            eventDaysLeft.text = "\(diffDateComponents.day!) days left."
        default:

            break
        }
        if     diffDateComponents.year == 0 &&
            diffDateComponents.day == 0 && 
            diffDateComponents.second == 0  &&
            diffDateComponents.minute == 0 &&
            diffDateComponents.hour == 0 &&
            diffDateComponents.day == 0
              {
                  self.countdownTimer?.invalidate()
                  self.countdownTimer = nil
                
        }
        
        return eventDaysLeft.text ?? "☑️"
    }

    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventDaysLeft: UILabel!
    
    
  
     var event: Event? {
         didSet {
             updateViews()
         }
     }
    
     
   
}
