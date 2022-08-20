//
//  SavedStocksTableViewController.swift
//  stocksApp
//
//  Created by Batuhan Ipci on 2022-08-19.
//

import UIKit
import CoreData

class SavedStocksTableViewController: UITableViewController {
    
    //SearchController
    let searchController = UISearchController()
    
    // NSManagedObjectContext
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<Stock>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MY Stocks"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search favorite stocks"
        navigationItem.searchController = searchController
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
        return fetchedResultsController.sections?.count ?? 1
        //print(fetchedResultsController.sections?.count)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedStockCell", for: indexPath) as! StockTableViewCell
        let stock = fetchedResultsController.object(at: indexPath)
        cell.companyNameLbl.text = stock.companyName
        cell.lastPriceLbl.text = String(stock.lastPrice)
        return cell
    }
}

extension SavedStocksTableViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let bar = searchController.searchBar.text
        print(bar!)
    }
}

// MARK: CoreData fetch
extension SavedStocksTableViewController : NSFetchedResultsControllerDelegate {
    func fetchSavedStocks() {
         self.fetchedResultsController = {
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
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
}
