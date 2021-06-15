//
//  ViewController.swift
//  DreamLister
//
//  Created by Herbert Dodge on 6/10/21.
//

import UIKit
import CoreData

class MainVC: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    var controller: NSFetchedResultsController<Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        tableView.delegate = self
        tableView.dataSource = self
//        generateDummyData()
        attemptFetch()
    }
}

//MARK: - Actions

extension MainVC {
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        attemptFetch()
        tableView.reloadData()
    }
}


extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId, for: indexPath) as? ItemCell else {return UITableViewCell()}
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(_ cell: ItemCell, indexPath: IndexPath) {
        let item = controller.object(at: indexPath)
        cell.configureCell(item)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

//MARK: - CoreData Setup
extension MainVC: NSFetchedResultsControllerDelegate {
    func generateDummyData() {
        let item1 = Item(context: Constants.context)
        item1.name = "Macbook Pro"
        item1.price = 3000
        item1.details = "I'd really like a new macbook with a keyboard that doesnt break all the time"
        
        let item2 = Item(context: Constants.context)
        item2.name = "Bose N700 Headphones"
        item2.price = 349
        item2.details = "They are pricey but being a ble to blcok out other people is worth it"
        
        let item3 = Item(context: Constants.context)
        item3.name = "Tesla Model Y"
        item3.price = 62000
        item3.details = "This is like buying the future"
        
        Constants.ad.saveContext()
        
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "name", ascending: true)
        
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            fetchRequest.sortDescriptors = [dateSort]
        case 1:
            fetchRequest.sortDescriptors = [priceSort]
        case 2:
            fetchRequest.sortDescriptors = [titleSort]
        default:
            break
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Constants.context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            print(error)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case.insert:
            if let indexpath = newIndexPath {
                tableView.insertRows(at: [indexpath], with: .fade)
            }
        case.delete:
            if let indexpath = indexPath {
                tableView.deleteRows(at: [indexpath], with: .fade)
            }
        case.update:
            if let indexpath = indexPath {
                let cell = tableView.cellForRow(at: indexpath) as! ItemCell
                configureCell(cell, indexPath: indexpath)
                
            }
        case.move:
            if let indexpath = indexPath {
                tableView.insertRows(at: [indexpath], with: .fade)
            }
            
        @unknown default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
