//
//  EventDetailVC.swift
//  Counter
//
//  Created by Nick Nguyen on 2/3/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class EventDetailVC: UIViewController {

    
    @IBOutlet weak var emojiView: UIView!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var date1Label: UILabel!
    @IBOutlet weak var date2Label: UILabel!
    
    
    var event: Event? 
       
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
           updateView()
      progressView.transform = progressView.transform.scaledBy(x: 1, y: 20)
     
    }
    
    func updateView() {
        guard let event = event else { return }
        
        
        
        emojiLabel.text = event.emoji
    }

}
