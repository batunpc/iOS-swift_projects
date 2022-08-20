//
//  SavedStocksTableViewController.swift
//  stocksApp
//
//  Created by Batuhan Ipci on 2022-08-19.
//

import UIKit
import CoreData

class SavedStocksTableViewController: UITableViewController {
    
    // NSManagedObjectContext
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var stockFetchedResultsController: NSFetchedResultsController<Stock>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MY Stocks"
        definesPresentationContext = true
        self.fetchSavedStocks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchSavedStocks()
        tableView.reloadData()
    }
    @IBAction func editBtnPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing{
            tableView.isEditing = false
        }else{
            tableView.isEditing = true
        }
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return stockFetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return stockFetchedResultsController.sections?[section].numberOfObjects ?? 0
        if let sections = stockFetchedResultsController.sections{
            return sections[section].numberOfObjects
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return stockFetchedResultsController.sections?[section].name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedStockCell", for: indexPath) as! StockTableViewCell
        let stock = stockFetchedResultsController.object(at: indexPath)
        cell.companyNameLbl.text = stock.companyName
        cell.lastPriceLbl.text = String(stock.lastPrice)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let deletedCity = self.stockFetchedResultsController.object(at: indexPath)
            self.context.delete(deletedCity)
            try? self.context.save()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var objects = stockFetchedResultsController.fetchedObjects!
        let object = stockFetchedResultsController.object(at: sourceIndexPath)
        objects.remove(at: sourceIndexPath.row)
        objects.insert(object, at: destinationIndexPath.row)
        DispatchQueue.main.async {
            tableView.reloadData()
            try? self.context.save()
        }
      
    }

}

// MARK: CoreData fetch
extension SavedStocksTableViewController : NSFetchedResultsControllerDelegate {
    func fetchSavedStocks() {
         self.stockFetchedResultsController = {
          let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
          let sortDescriptor = NSSortDescriptor(key: "category", ascending: false)
          fetchRequest.sortDescriptors = [sortDescriptor]

          let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category",
            cacheName: nil)
              do {
                  try fetchedResultsController.performFetch()
              } catch {
                  print(error.localizedDescription)
              }
          return fetchedResultsController
        }()
        stockFetchedResultsController.delegate = self
        do {
            try stockFetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError("Error")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
        case .move, .update:
            fatalError("Error")
        @unknown default:
            fatalError("Error")
        }
    }
}
