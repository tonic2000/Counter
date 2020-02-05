//
//  ViewController.swift
//  Counter
//
//  Created by Nick Nguyen on 1/31/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class MainVC: UIViewController, NewEventTableViewControllerDelegate {
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    
    func didReceivedNewEvent(name: String, emoji: String, content: String, date: Date, dayleft: Double) {
        eventController.createEvent(name: name, emoji: emoji, date: date, content: content, daysLeft: dayleft)
        
        print(eventController.events.count)
        eventTableView.reloadData()
    }


    @IBOutlet weak var eventTableView: UITableView!
    
    
    var eventController = EventController()
    
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
            destVC.delegate2 = self
            destVC.event = event
      
        default:
            break
       
        }
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
    
    @IBAction func settingTapped(_ sender: UIBarButtonItem) {
        
        
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
    
}


