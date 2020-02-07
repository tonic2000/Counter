//
//  EventDetailVC.swift
//  Counter
//
//  Created by Nick Nguyen on 2/3/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit


protocol EventDetailVCDelegate : AnyObject {
    func didEndTimer()
}


class EventDetailVC: UIViewController , UIGestureRecognizerDelegate {
   
    @IBOutlet weak var nameEventLabel: UILabel!
    @IBOutlet weak var shareButtonBackgroundView: UIView!
    @IBOutlet weak var emojiBackgroundView: UIView!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var date1Label: UILabel!
   
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
   
    @IBOutlet weak var yearsLabel: UILabel!
    @IBOutlet weak var monthsLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
  

    
    @IBOutlet weak var yearsNumLabel: UILabel!
    @IBOutlet weak var dayNumLabel: UILabel!
    @IBOutlet weak var monthNumLabel: UILabel!
    @IBOutlet weak var hourNumLabel: UILabel!
    @IBOutlet weak var minNumLabel: UILabel!
    @IBOutlet weak var secNumLabel: UILabel!
    
    
    
    private let dateFormatter = Helper.createDateFormatter(format: "E, d MMM yyyy HH:mm:ss")
     
    var event: Event?
    
    weak var delegate2: EventDetailVCDelegate?
    
    var countdownTimer : Timer?

   
    //MARK:-  App Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          self.updateTime()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTimer()
        updateView()
        
        let tap  = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.delegate = self
        
        emojiBackgroundView.addGestureRecognizer(tap)
      
    }
   
    func startTimer() {
    
    countdownTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                             target: self,
                                             selector: #selector(updateTime),
                                             userInfo: nil,
                                             repeats: true)
   
    }
  

    @objc func updateTime() {

        let currentDate = Date()
         let calendar = Calendar.current
        guard let eventDate = event?.date else { return }
         let diffDateComponents = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: currentDate,to: eventDate)
        
        guard let year = diffDateComponents.year,
            let month = diffDateComponents.month,
            let day = diffDateComponents.day,
            let hour = diffDateComponents.hour ,
            let minute = diffDateComponents.minute,
            let second = diffDateComponents.second
            
            
            else { return }
        
        
        DispatchQueue.main.async {
            self.secondsLabel.text  = second != 1 ? "seconds" : "second"
            self.minutesLabel.text = minute != 1 ? "minutes" : "minute"
            self.hoursLabel.text = hour != 1 ? "hours" : "hour"
            self.daysLabel.text = day != 1 ? "days" : "day"
            self.monthsLabel.text = month != 1 ? "months" : "month"
            self.yearsLabel.text = year != 1 ? "years" : "year"
            
            
            
            
            self.secNumLabel.text = second > 0 ? "\(second)" : "0"
            self.minNumLabel.text =  minute > 0 ?  "\(minute)" : "0"
            self.hourNumLabel.text = hour > 0 ?  "\(hour)" : "0"
            self.dayNumLabel.text =  day > 0 ?  "\(day)" : "0"
            self.monthNumLabel.text = month > 0 ? "\(month)" : "0"
            self.yearsNumLabel.text =  year > 0 ?   "\(year)" : "0"
            
            
            
            if diffDateComponents.second == 0  &&
                diffDateComponents.minute == 0 &&
                diffDateComponents.hour == 0 &&
                diffDateComponents.day == 0 &&
                diffDateComponents.month == 0 &&
                diffDateComponents.year == 0
            {
                self.countdownTimer = nil
                self.countdownTimer?.invalidate()
                
                self.dismiss(animated: true, completion: nil)
//                self.delegate2?.didEndTimer()
            }
        }
      
    
    }
   
 
   private func updateView() {
         guard let event = event else { return }
    
    emojiBackgroundView.layer.cornerRadius = emojiBackgroundView.frame.size.width / 2
    emojiBackgroundView.layer.borderColor = UIColor.gray.cgColor
    emojiBackgroundView.clipsToBounds = true
    emojiBackgroundView.layer.borderWidth = 5
    
    backButtonBackgroundView.layer.cornerRadius = backButtonBackgroundView.frame.size.width / 2
    shareButtonBackgroundView.layer.cornerRadius = shareButtonBackgroundView.frame.size.width / 2
    
    nameEventLabel.text = event.name
    date1Label.text = dateFormatter.string(from: event.date)
    
    emojiLabel.text = event.emoji
    emojiLabel.textAlignment = .center
    
    }

    // MARK: - UIActivityViewController
    
    @IBAction func shareTapped(_ sender: UIButton) {
             let bounds = UIScreen.main.bounds
              UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
              self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
              let img = UIGraphicsGetImageFromCurrentImageContext()
              UIGraphicsEndImageContext()
              let activityViewController = UIActivityViewController(activityItems: [img ?? "No image"], applicationActivities: nil)
              self.present(activityViewController, animated: true, completion: nil)
    }
    
    
     @objc func handleTap(sender: UITapGestureRecognizer) {
          
        view.alpha =  0.5
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "alert") as! AlertViewController
        myAlert.delegate = self
        
        myAlert.modalPresentationStyle = .overCurrentContext
        myAlert.modalTransitionStyle = .crossDissolve
        self.present(myAlert, animated: true, completion: nil)
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        delegate2?.didEndTimer()
    }
    
    @IBOutlet weak var backButtonBackgroundView: UIView!
    
}



    
    

