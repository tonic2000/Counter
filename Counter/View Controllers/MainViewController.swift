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

class MainViewController: UIViewController {
    
    //MARK:-IBOutlets
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var menuViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var eventTableView: UITableView! {
        didSet {
            eventTableView.dataSource = self
            eventTableView.delegate = self
            eventTableView.tableFooterView = UIView()
        }
    }
    
    let eventController = EventController()
    private var menuShowing = false
    private var event: Event?
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortButton.isEnabled = eventController.events.count > 1 ? true : false
        setUpForMenuView()
        
        //MARK: - Hide row when not in used.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventTableView.reloadData()
        sortButton.isEnabled = eventController.events.count > 1 ? true : false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        animateTable()
    }
    //MARK: - TODO : Animate table view
    
    private func animateTable() {
        eventTableView.reloadData()
        
        let cells = eventTableView.visibleCells
        let tableHeight = eventTableView.bounds.size.height
        
        // move all cells to the bottom of the screen
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        // move all cells from bottom to the right place
        var index = 0
        for cell in cells {
            UIView.animate(withDuration: 2, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
            index += 1
        }
    }
    
    private func setUpForMenuView() {
        menuViewLeadingConstraint.constant = -400
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 6
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier  {
            case Utilities.addButtonSegue:
                guard  let destVC = segue.destination as? NewEventTableViewController else { return }
                
                destVC.eventController = eventController
                
            case Utilities.clickCellSegue:
                
                guard let destVC = segue.destination as? EventDetailViewController else { return }
                guard  let sender = (sender as? EventCell) else { return }
                guard let indexPath = eventTableView.indexPath(for: sender) else { return }
                let event = eventController.events[indexPath.row]
                
                destVC.event = event
                
            case Utilities.swipeLeftSegue :
                guard let index = sender as? IndexPath,
                      let destVC = segue.destination as? NewEventTableViewController else { return }
                let event = eventController.events[index.row]
                destVC.event = event
                destVC.eventController = eventController
                
            default:
                break
        }
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        menuViewLeadingConstraint.constant =  -400
        menuShowing.toggle()
        eventTableView.alpha = 1.0
        addButton.alpha = 1.0
        bottomView.alpha = 1.0
        navigationController?.navigationBar.alpha = 1.0
        addButton.isEnabled = true
        sortButton.isEnabled = true
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        print("He")
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
            bottomView.alpha = 1.0
            navigationController?.navigationBar.alpha = 1.0
            addButton.isEnabled = true
            sortButton.isEnabled = true
            
            
        } else {
            // Slide out
            addButton.alpha = 0.5
            addButton.isEnabled = false
            sortButton.isEnabled = false
            bottomView.alpha = 0.5
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
        Utilities.openTwitter()
    }
    
    @IBAction func feedbackTapped(_ sender: UIButton) {
        sendEmail()
    }
    
    @IBAction func appsTapped(_ sender: UIButton) {
        let urlStr = "https://apps.apple.com/us/developer/thinh-nguyen/id1475297118"
        UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
    }
}
