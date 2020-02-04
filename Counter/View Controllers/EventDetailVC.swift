//
//  EventDetailVC.swift
//  Counter
//
//  Created by Nick Nguyen on 2/3/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class EventDetailVC: UIViewController {
    
    
   
    
    @IBOutlet weak var exampleView: UIView!
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss  "
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    func updateView() {
        
        guard let event = event else { return }
        emojiLabel.text = event.emoji
        eventNameLabel.text = event.name
        date1Label.text = dateFormatter.string(from: event.date)
          
    }

    var event: Event?
    
    func setUpToolBar() {
        
    }
           override func viewWillAppear(_ animated: Bool) {
                 super.viewWillAppear(animated)
                startOtpTimer()
             }
             
             override func viewDidLoad() {
                 super.viewDidLoad()
                exampleView.layer.cornerRadius = view.frame.size.width / 2
                updateView()
               progressView.transform = progressView.transform.scaledBy(x: 1, y: 20)
              
             }
             
        
    
     
//    var timer = Timer()
    
    
    
    var timer: Timer?
        var totalTime = 0

        private func startOtpTimer() {
            self.totalTime = Int(event!.daysLeft)
               self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
           }

       @objc func updateTimer() {
               print(self.totalTime)
        self.date2Label.text = dateFormatter.string(from: Date(timeInterval: event!.daysLeft, since: Date()))
               if totalTime != 0 {
                   totalTime -= 1  // decrease counter timer
               } else {
                   if let timer = self.timer {
                       timer.invalidate()
                       self.timer = nil
                   }
               }
           }
     
    
    
    @IBOutlet weak var emojiView: UIView!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var date1Label: UILabel!
    @IBOutlet weak var date2Label: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
  
    
    
}
