//
//  ViewController.swift
//  Counter
//
//  Created by Nick Nguyen on 1/31/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//
// Nick version

import UIKit
import MessageUI

class MainVC: UIViewController, NewEventTableViewControllerDelegate {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var sortButton: UIBarButtonItem!

    @IBOutlet weak var menuViewLeadingConstraint: NSLayoutConstraint!
    func didReceivedNewEvent(name: String, emoji: String, content: String, date: Date, dayleft: Double) {
//        eventController.createEvent(name: name, emoji: emoji, date: date, content: content, daysLeft: dayleft)
        print(eventController.events.count)
        eventTableView.reloadData()
    }

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var eventTableView: UITableView!

    let eventController = EventController()
    var menuShowing = false 
    var event: Event?
       
   //MARK: - App Life Cycle
    
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       eventTableView.reloadData()
       sortButton.isEnabled = eventController.events.count > 1 ? true : false
      self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.dataSource = self
        eventTableView.delegate = self
        
         sortButton.isEnabled = eventController.events.count > 1 ? true : false
        setUpForMenuView()
     
   //MARK: - Hide row when not in used.
 eventTableView.tableFooterView = UIView()
        
    }
    
    private func setUpForMenuView() {
        menuViewLeadingConstraint.constant = -400
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 6
    }
 
 // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        switch segue.identifier  {
        case Helper.addButtonSegue:
              guard  let destVC = segue.destination as? NewEventTableVC else { return }
            destVC.delegate = self
            destVC.eventController = eventController
           
        case Helper.clickCellSegue:
            
            guard let destVC = segue.destination as? EventDetailVC else { return }
            guard  let sender = (sender as? EventCell) else { return }
            guard let indexPath = eventTableView.indexPath(for: sender) else { return } //
            let event = eventController.events[indexPath.row]

            destVC.event = event
         
        case Helper.swipeLeftSegue :
            guard let index = sender as? IndexPath,
                           let destVC = segue.destination as? NewEventTableVC else { return }
                       let event = eventController.events[index.row]
                       destVC.event = event
                       destVC.eventController = eventController
            
            
            //MARK:- TODO 
        default:
            break
       
        }
    }

    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        menuViewLeadingConstraint.constant =  -400
        menuShowing.toggle()
        eventTableView.alpha = 1.0
                   addButton.alpha = 1.0
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
      
    }
    
    
    @IBAction func addTapped(_ sender: UIButton) {
        //Segue 
    }
    
    
    @IBAction func sortTapped(_ sender: UIBarButtonItem) {
        
        switch sender.title {
        case "Sort":
            showAlert()
            
        default:
            sender.title = "Sort"
            eventTableView.isEditing = false
             addButton.isEnabled = true
        }
       
       
    }
    
    private func showAlert() {
        let ac = UIAlertController(title: "SORT EVENTS", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Sort alphabetically", style: .default, handler: { (action) in
            self.eventController.sortAlphabetically()
            self.eventTableView.reloadData()
        }))
        
        ac.addAction(UIAlertAction(title: "Sort from Soonest to Furthest", style: .default, handler: sortTime(action:) ))
        ac.addAction(UIAlertAction(title: "Sort manually", style: .default, handler: moveCell(action:)))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        present(ac, animated: true, completion: nil)
    }
    
    
    func sortTime(action: UIAlertAction)  {
        
        eventController.sortTime()
        self.eventTableView.reloadData()
          
    }
    
   // MARK: - Side menu
    
    @IBAction func settingTapped(_ sender: UIBarButtonItem) {

        if menuShowing {
            // Slide in
            menuViewLeadingConstraint.constant = -400
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
            eventTableView.alpha = 1.0
            addButton.alpha = 1.0
            navigationController?.navigationBar.alpha = 1.0
            
        } else {
            // Slide out
            addButton.alpha = 0.5
            menuViewLeadingConstraint.constant = 0
            navigationController?.navigationBar.alpha = 0.5
            eventTableView.alpha = 0.5
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
        
        menuShowing.toggle()
        
    }
    
   private func moveCell(action: UIAlertAction) {
          addButton.isEnabled = false
        self.eventTableView.isEditing.toggle()
        switch eventTableView.isEditing {
        case true:
            sortButton.title = "Edit"
        default:
            sortButton.title = "Sort"
        }
               
         
    }
  
    @IBAction func contactTapped(_ sender: UIButton) {
        Helper.openTwitter()
    }
   
    @IBAction func feedbackTapped(_ sender: UIButton) {
        sendEmail()
    }

    @IBAction func appsTapped(_ sender: UIButton) {
        let urlStr = "https://apps.apple.com/us/developer/thinh-nguyen/id1475297118"
        UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
    }

}



