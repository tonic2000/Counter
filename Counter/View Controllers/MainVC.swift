//
//  ViewController.swift
//  Counter
//
//  Created by Nick Nguyen on 1/31/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class MainVC: UIViewController, NewEventTableViewControllerDelegate {
    func didReceivedNewEvent(name: String, emoji: String, content: String, date: Date, dayleft: Double) {
        eventController.createEvent(name: name, emoji: emoji, date: date, content: content, daysLeft: dayleft)
        
        print(eventController.events.count)
        eventTableView.reloadData()
    }


    @IBOutlet weak var eventTableView: UITableView!
    
    
    var eventController = EventController()
    var event: Event?
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         eventTableView.reloadData()
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.dataSource = self
        eventTableView.delegate = self
       
     
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEventSegue" {
            guard  let destVC = segue.destination as? NewEventTableVC else { return }
            destVC.delegate = self
            destVC.eventController = eventController
        }
    }


    @IBAction func addTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func sortTapped(_ sender: UIBarButtonItem) {
    }
    
    
    @IBAction func settingTapped(_ sender: UIBarButtonItem) {
    }
    
    
}
extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO
      
      
        return eventController.events.count
       
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EvenCell123", for: indexPath) as? EventCell else {
            return UITableViewCell()
        }
        cell.event = event
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            eventController.events.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
}
