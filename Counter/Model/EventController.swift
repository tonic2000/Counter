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
    
    init() {
        loadFromPersistentStore()
    }
    
    func createEvent( name: String, emoji: String, date: Date, content: String?, daysLeft: Double)  {
        let event = Event(name: name, emoji: emoji, letterContent: content, date: date, daysLeft: daysLeft)
        events.append(event)
        saveToPersistStore()
    }
    
   //MARK: - Saving Data
    
    var eventURL : URL? {
             let fm = FileManager.default
             guard let documentDirectory = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
             let eventURL = documentDirectory.appendingPathComponent("Events.plist")
             return eventURL
         }
      
      private func saveToPersistStore() {
             guard let fileURL = eventURL else { return }
             do {
                  let encoder = PropertyListEncoder()
                 let eventData = try encoder.encode(events)
                 try eventData.write(to: fileURL)
             } catch  let err {
                 print("Can't save events.Error : \(err)")
             }
            
         }
         
        private func loadFromPersistentStore() {
             guard let fileURL = eventURL else { return }
             do {
                 let eventData = try Data(contentsOf: fileURL)
                 let decoder = PropertyListDecoder()
                 let decodedEvent = try  decoder.decode([Event].self, from: eventData)
                 self.events = decodedEvent
             } catch let err {
                 print("Can't load Data , error: \(err)")
             }
         }
    
    func deleteEvent(event: Event) {
        guard let event = events.firstIndex(of: event) else { return }
        events.remove(at: event)
        saveToPersistStore()
    }
    
    
    func sortTime() {
        events.sort { $0.daysLeft < $1.daysLeft }
        saveToPersistStore()
    }
    
    
    func sortAlphabetically() {
       events.sort(by: < )
        saveToPersistStore()
    }
    
    
    
    func update(event: Event, name: String, content: String?,date: Date,emoji: String,daysLeft: Double) {
         guard  let indexPath = events.firstIndex(of: event) else { return }
           
           event.name = name
           event.letterContent = content
           event.date = date
           event.emoji = emoji
           event.daysLeft = daysLeft
           
           events.remove(at: indexPath)
           events.insert(event, at: indexPath)
        saveToPersistStore()
       }

    
}
