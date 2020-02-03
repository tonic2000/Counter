//
//  Event.swift
//  Counter
//
//  Created by Nick Nguyen on 2/3/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation


class Event : Codable {
    var name: String
    var emoji: String
    var letterContent: String?
    var date: Date
    var daysLeft: Double
    
    init(name: String, emoji: String, letterContent: String?,date: Date, daysLeft: Double) {
        self.name = name
        self.emoji = emoji
        self.letterContent = letterContent
        self.date = date
        self.daysLeft = daysLeft
    }
    
}
