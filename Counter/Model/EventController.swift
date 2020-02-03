//
//  EventController.swift
//  Counter
//
//  Created by Nick Nguyen on 2/3/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation


class EventController  {
    
    var events = [Event]()
    
    
    func createEvent( name: String, emoji: String, date: Date, content: String?, daysLeft: Double)  {
        let event = Event(name: name, emoji: emoji, letterContent: content, date: date, daysLeft: daysLeft)
        events.append(event)

    }
    
    
    
}
