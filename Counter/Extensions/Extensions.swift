//
//  Extensions.swift
//  Counter
//
//  Created by Nick Nguyen on 2/5/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation
import UIKit


extension EventDetailVC: AlertViewControllerDelegate {
    func didTapOnScreen() {
    view.alpha = 1.0
    }
}

extension Date {
    static func differ(lhs:Date,rhs:Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

extension MainVC: EventDetailVCDelegate {
    func didEndTimer() {
     let new = eventController.events.filter {
            $0.daysLeft != 0
           
            }
         eventController.events = new
         eventTableView.reloadData()
        
    }
}

// MARK: - TableView DataSource and Delegate

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventController.events.count
       
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell123", for: indexPath) as? EventCell else
        {
            return UITableViewCell()
        }
        
         let event = eventController.events[indexPath.row] //
        cell.event = event
        
        return cell
        
    }
    
  //Swipe to delete
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//             eventController.deleteEvent(event: eventController.events[indexPath.row])
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//
//
//        }
//    }

   
//Move cell
     func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
   
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.eventController.events[sourceIndexPath.row]
        eventController.events.remove(at: sourceIndexPath.row)
        eventController.events.insert(movedObject, at: destinationIndexPath.row)
    }
    
   // New way to delete cell
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.eventController.deleteEvent(event: self.eventController.events[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            success(true)
        })
        
        modifyAction.backgroundColor = .red
        modifyAction.image = UIImage(systemName: "trash")
        
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let modifyAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            self.performSegue(withIdentifier: Helper.swipeLeftSegue, sender: indexPath)
            //MARK: - TODO
            
            
          print("Trying to edit for pass data for cell")
                   
                   success(true)
               })
             
        modifyAction.backgroundColor = UIColor(displayP3Red: 216/255, green: 191/255, blue: 216/255, alpha: 1.0)
        modifyAction.image = UIImage(systemName: "gobackward")
           
               return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    
   
    
}




