//
//  SearchStockViewController.swift
//  stocksApp
//
//  Created by Batuhan Ipci on 2022-08-18.
//

import UIKit
import CoreData

class SearchStockViewController: UIViewController {
    
    var selectedCompany = ""
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // Search controller
    lazy var searchController = UISearchController(searchResultsController: addStockTableVC)
    lazy var addStockTableVC = self.storyboard?.instantiateViewController(withIdentifier: "addStockTableVC") as! AddStockTableViewController
        
    // STOCK NSManagedObjectContext - reference to the Core Data persistent container
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //core data fetchedResultsController
        self.prepareFetchedResultsController()
        //custom delegate
        addStockTableVC.delegate = self
        //searchController
        title = "Add Stock"
        searchController.searchBar.placeholder = "Search stocks"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    //Autofocus on searchbar
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    @IBAction func selectedPortion(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0 :
            print("Active portion selected")
        case 1 :
            print("Watch List portion selected")
        default:
            break
        }
    }
    
    @IBAction func addStockPressed(_ sender: Any) {
        let performanceId = addStockTableVC.companyList.map{$0.performanceId.description}
        saveStock(id: performanceId[0])
    }
    
    func saveStock(id: String){
        //Save the NSManagedObject
        let stock = Stock(context: context)
       
        //Retrieve lastPrice using performance Id
        _ = ServiceManager.getStockPrice(route: .realTimePrice(id), method: .get) { result in
            switch result {
            case.failure(let error):
                print(error.localizedDescription)
            case.success(let lastPrice):
                stock.companyName = self.selectedCompany
                stock.lastPrice = Double(lastPrice) ?? 0
                try? self.context.save() // save the data
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            
            print("\(self.selectedCompany) has been saved.")
        }
    }
}

// Search Results
extension SearchStockViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        //autocompletion
        _ = ServiceManager.createRequest(route: .companySearch(searchText), method: .get) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.description)
            case .success(let company):
                DispatchQueue.main.async {
                    //print(company?.description)
                    self?.addStockTableVC.companyList = company ?? []
                    self?.addStockTableVC.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: = protocol to get the company name
extension SearchStockViewController: TableStocksDelegate {
    func companySelected(data: CompanyDetail) {
        let companyName = data.name
        title = companyName
        print("\(companyName) Company selected")
        selectedCompany = companyName
        searchController.isActive = false
    }
}

// MARK: CoreData fetch
extension SearchStockViewController : NSFetchedResultsControllerDelegate {
    func prepareFetchedResultsController() {
        lazy var fetchedResultsController:
          NSFetchedResultsController<Stock> = {
          let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
          let sortDescriptor = NSSortDescriptor(key: "companyName", ascending: false)
          fetchRequest.sortDescriptors = [sortDescriptor]
          let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "lastPrice",
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
