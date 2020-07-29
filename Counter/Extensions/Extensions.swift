//
//  Extensions.swift
//  Counter
//
//  Created by Nick Nguyen on 2/5/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

extension EventDetailVC: AlertViewControllerDelegate {
  func didTapOnScreen() {
    view.alpha = 1.0
  }
}

// MARK: - TableView DataSource and Delegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return eventController.events.count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell123", for: indexPath) as? EventCell else
    {
      return UITableViewCell()
    }
    let event = eventController.events[indexPath.row]
    
    cell.event = event
    
    return cell
    
  }

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
      tableView.deleteRows(at: [indexPath], with: .fade)
      
      success(true)
    })
    
    modifyAction.backgroundColor = .red
    modifyAction.image = UIImage(systemName: "trash")
    
    
    return UISwipeActionsConfiguration(actions: [modifyAction])
  }
  
  
  //MAKR: - Footer View .
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
    let label = UILabel()
    label.text = "No events to display."
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 18)
    view.addSubview(label)
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: eventTableView.safeAreaLayoutGuide.topAnchor,constant: 16),
      label.centerXAnchor.constraint(equalTo: eventTableView.centerXAnchor)
      
    ])
    
    return label
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return eventController.events.count == 0 ? 150 : 0
  }
  
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let modifyAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
      
      self.performSegue(withIdentifier: Helper.swipeLeftSegue, sender: indexPath) // "A-ha" 1
      success(true)
    })
    
    modifyAction.backgroundColor = UIColor(displayP3Red: 216/255, green: 191/255, blue: 216/255, alpha: 1.0)
    modifyAction.image = UIImage(systemName: "gobackward")
    
    return UISwipeActionsConfiguration(actions: [modifyAction])
  }
  
}
//MARK:- Send Email
extension MainViewController: MFMailComposeViewControllerDelegate {
  func sendEmail() {
    if MFMailComposeViewController.canSendMail() {
      let mail = MFMailComposeViewController()
      mail.mailComposeDelegate = self
      mail.setToRecipients(["ptnguyen1901@gmail.com"])
      mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
      
      present(mail, animated: true)
    } else {
      let ac = UIAlertController(title: "Error sending email", message: "Your device does not support email, please try again later.", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
      present(ac, animated: true)
    }
  }
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    
    if let _ = error {
      controller.dismiss(animated: true)
    }
    switch result {
      case .cancelled:
        controller.dismiss(animated: true)
      default:
        controller.dismiss(animated: true)
    }
  }
}



