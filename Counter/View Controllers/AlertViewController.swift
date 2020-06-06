//
//  AlertViewController.swift
//  Counter
//
//  Created by Nick Nguyen on 2/4/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

protocol AlertViewControllerDelegate : AnyObject {
    func didTapOnScreen()
}


class AlertViewController: UIViewController , UIGestureRecognizerDelegate {

  weak  var delegate: AlertViewControllerDelegate?
    
    @IBOutlet weak var quoteView: UIView!
    @IBOutlet weak var quoteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.delegate = self
        view.addGestureRecognizer(tap)

        quoteLabel.text = Quotes.quotes.randomElement()
        
    }
    

    @objc func handleTap() {
        dismiss(animated: true, completion: nil)
        delegate?.didTapOnScreen()
    }
}
