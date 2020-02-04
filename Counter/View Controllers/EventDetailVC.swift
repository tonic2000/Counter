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
    
    var countdownTimer : Timer?

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
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    weak var delegate2: EventDetailVCDelegate?
   
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        
    }

    @objc func updateTime() {

        let currentDate = Date()
         let calendar = Calendar.current
        
         let diffDateComponents = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: currentDate,to: event!.date)
        
        guard let year = diffDateComponents.year,
            let month = diffDateComponents.month,
            let day = diffDateComponents.day,
            let hour = diffDateComponents.hour ,
            let minute = diffDateComponents.minute,
            let second = diffDateComponents.second
            
            
            else { return }
        
        
        
        secondsLabel.text  = second != 1 ? "seconds" : "second"
        minutesLabel.text = minute != 1 ? "minutes" : "minute"
        hoursLabel.text = hour != 1 ? "hours" : "hour"
        daysLabel.text = day != 1 ? "days" : "day"
        monthsLabel.text = month != 1 ? "months" : "month"
        yearsLabel.text = year != 1 ? "years" : "year"
        
        
        
    
        secNumLabel.text = second > 0 ? "\(second)" : "0"
        minNumLabel.text =  minute > 0 ?  "\(minute)" : "0"
        hourNumLabel.text = hour > 0 ?  "\(hour)" : "0"
        dayNumLabel.text =  day > 0 ?  "\(day)" : "0"
        monthNumLabel.text = month > 0 ? "\(month)" : "0"
        yearsNumLabel.text =  year > 0 ?   "\(year)" : "0"
        
        
      
        if diffDateComponents.second == 0  && diffDateComponents.minute == 0 && diffDateComponents.hour == 0 && diffDateComponents.day == 0 && diffDateComponents.month == 0 && diffDateComponents.year == 0 {
             countdownTimer?.invalidate()
            countdownTimer = nil
           dismiss(animated: true, completion: nil)
            delegate2?.didEndTimer()
        }
    
    }
 
    func updateView() {
         guard let event = event else { return }
        
        emojiBackgroundView.layer.cornerRadius = emojiBackgroundView.frame.size.width / 2
        emojiBackgroundView.layer.borderColor = UIColor.gray.cgColor
        emojiBackgroundView.clipsToBounds = true
        emojiBackgroundView.layer.borderWidth = 5.0
        
        backButtonBackgroundView.layer.cornerRadius = backButtonBackgroundView.frame.size.width / 2
        shareButtonBackgroundView.layer.cornerRadius = shareButtonBackgroundView.frame.size.width / 2
       
        nameEventLabel.text = event.name
        date1Label.text = dateFormatter.string(from: event.date)
        
        emojiLabel.text = event.emoji
        emojiLabel.textAlignment = .center
    
    }

    var event: Event?
    
             
    override func viewDidLoad() {
        super.viewDidLoad()
       let tap  = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        
        tap.delegate = self
        
        emojiBackgroundView.addGestureRecognizer(tap)
        updateView()
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 20)
        startTimer()
    }
    
    
    
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
    }
    
    @IBOutlet weak var backButtonBackgroundView: UIView!
    
}


extension EventDetailVC: AlertViewControllerDelegate {
    func didTapOnScreen() {
        view.alpha = 1.0
    }
    
    
}
