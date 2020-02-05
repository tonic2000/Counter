//
//  EventCell.swift
//  Counter
//
//  Created by Nick Nguyen on 2/3/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import Foundation

class EventCell: UITableViewCell  {
    var countdownTimer : Timer?
    
    let dateFormatter  = Helper.createDateFormatter(format:" E, d MMM yyyy")
    
    
    
    private  func updateViews() {
        guard let event = event else { return }
         startTimer()
        eventNameLabel.text = event.name
        emojiLabel.text = event.emoji
       
        eventDateLabel.text = dateFormatter.string(from: event.date)
//        eventDaysLeft.text = event.daysLeft > 0.0 ? updateTime() : "☑️"
        eventDaysLeft.backgroundColor = UIColor(displayP3Red: 176/255, green: 196/255, blue: 222/255, alpha: 1.0)
      
       updateTime()
      
    }
   private func startTimer() {
    
    countdownTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                             target: self,
                                             selector: #selector(updateTime),
                                             userInfo: nil,
                                             repeats: true)
   
    }
    
    @objc func updateTime()  {
        
        let currentDate = Date()
        let calendar = Calendar.current
        let diffDateComponents = calendar.dateComponents([.day,.hour,.minute,.second], from: currentDate,to: event!.date)

        switch Int(event!.daysLeft) {
            
            // MARK: - TODO
        case  ...0 :
            eventDaysLeft.text = "☑️"
            
            countdownTimer?.invalidate()
            countdownTimer = nil
            
        case 0...59:
            eventDaysLeft.text = "\(diffDateComponents.second!) seconds left."
        case 60...3599:
            eventDaysLeft.text = "\(diffDateComponents.minute!) minutes left."
        case 3600...86399:
            eventDaysLeft.text = "\(diffDateComponents.hour!) hours, \(diffDateComponents.minute!) mins left."
        case let x where x >= 86400 :
            eventDaysLeft.text = "\(diffDateComponents.day!) days left."
        default:
            eventDaysLeft.text = "☑️"
            countdownTimer?.invalidate()
            break
        }
        if diffDateComponents.second == 0  &&
                  diffDateComponents.minute == 0 &&
                  diffDateComponents.hour == 0 &&
                  diffDateComponents.day == 0 &&
                  diffDateComponents.month == 0 &&
                  diffDateComponents.year == 0
              {
                  self.countdownTimer?.invalidate()
                  self.countdownTimer = nil }
        
       
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
