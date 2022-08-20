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
        //fetchSavedStocks()
        self.fetchSavedStocks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchSavedStocks()
        tableView.reloadData()
    }
    

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return stockFetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedStockCell", for: indexPath) as! StockTableViewCell
        let stock = stockFetchedResultsController.object(at: indexPath)
        cell.companyNameLbl.text = stock.companyName
        cell.lastPriceLbl.text = String(stock.lastPrice)
        return cell
    }
    //MARK: TODO
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        //return stockFetchedResultsController.sections?[section].name
//        return categoryFetchedResultsController.sections?[section].name
//    }
}

extension SavedStocksTableViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let bar = searchController.searchBar.text
        //MARK: TODO:
        print(bar!)
    }
}

// MARK: CoreData fetch
extension SavedStocksTableViewController : NSFetchedResultsControllerDelegate {
    func fetchSavedStocks() {
         self.stockFetchedResultsController = {
          let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
          let sortDescriptor = NSSortDescriptor(key: "companyName", ascending: false)
          fetchRequest.sortDescriptors = [sortDescriptor]
          let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "companyName",
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
}
