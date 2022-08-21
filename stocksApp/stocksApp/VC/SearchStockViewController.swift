//
//  SearchStockViewController.swift
//  stocksApp
//
//  Created by Batuhan Ipci on 2022-08-18.
//

import UIKit
import CoreData

class SearchStockViewController: UIViewController {
    
    var companyManager = CompanyValue(id: "", selectedCompany: "", selectedCategory: "")
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //var id = "" , selectedCompany = "", selectedCategory = ""
    // Search controller
    lazy var searchController = UISearchController(searchResultsController: addStockTableVC)
    lazy var addStockTableVC = self.storyboard?.instantiateViewController(withIdentifier: "addStockTableVC") as! AddStockTableViewController
        
    // STOCK NSManagedObjectContext - reference to the Core Data persistent container
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        //selectedCategory = "Active"
        companyManager.selectedCategory = "Active"
    }
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.view.center
        self.view.addSubview(indicator)
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
            companyManager.selectedCategory = "Active"
        case 1 :
            companyManager.selectedCategory = "Watch List"
        default:
            break
        }
    }
    
    @IBAction func addStockPressed(_ sender: Any) {
        let performanceId = addStockTableVC.companyList.map{$0.performanceId?.description}
        if performanceId.isEmpty{return} else {
            saveStock(id: performanceId[0] ?? "")
        }   
    }
    
    
    func saveStock(id: String){
        //Save the NSManagedObject
        let stock = Stock(context: context)
        //Retrieve lastPrice using performance Id
        activityIndicator()
        indicator.startAnimating()
        indicator.backgroundColor = .white
        
        _ = ServiceManager.getStockPrice(route: .realTimePrice(id), method: .get) { result in
            switch result {
            case.failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true
                }
            case.success(let lastPrice):
                stock.category = self.companyManager.selectedCategory
                stock.companyName = self.companyManager.selectedCompany
                stock.performanceID = self.companyManager.id
                stock.lastPrice = Double(lastPrice) ?? 0
                try? self.context.save() // save the data
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true
                }
          
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            
            print("\(self.companyManager.selectedCompany) has been saved into \(self.companyManager.selectedCategory) category")
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
        let performanceID = data.performanceId
        title = companyName
        self.companyManager.selectedCompany = companyName
        self.companyManager.id = performanceID ?? ""
        searchController.isActive = false
        
    }
}


