//
//  EventDetailVC.swift
//  Counter
//
//  Created by Nick Nguyen on 2/3/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class EventDetailVC: UIViewController , UIGestureRecognizerDelegate {
    
    @IBOutlet weak var nameEventLabel: UILabel!
    
    @IBOutlet weak var shareButtonBackgroundView: UIView!
    @IBOutlet weak var emojiBackgroundView: UIView!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var date1Label: UILabel!
    @IBOutlet weak var date2Label: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
    
    
    
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    
    
    
    
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
        date2Label.text = "Countdown:\(event.daysLeft)"
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
