//
//  EventCell.swift
//  Counter
//
//  Created by Nick Nguyen on 2/3/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import Foundation

class EventCell: UITableViewCell {
   
    
    private  func updateViews() {
        guard let event = event else { return }
        eventNameLabel.text = event.name
        emojiLabel.text = event.emoji
        
        eventDateLabel.text = dateFormatter.string(from: event.date)
        eventDaysLeft.text = event.daysLeft > 0.0 ? "\(Int(event.daysLeft)) days left" : "☑️"
        eventDaysLeft.backgroundColor = UIColor(displayP3Red: 38/255, green: 50/255, blue: 72/255, alpha: 1.0)
        
    }
   
    private var dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "E, d MMM yyyy"
           formatter.timeZone = TimeZone(secondsFromGMT: 0)
           return formatter
       }()
    
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
