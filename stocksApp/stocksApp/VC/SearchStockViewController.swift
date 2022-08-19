//
//  SearchStockViewController.swift
//  stocksApp
//
//  Created by Batuhan Ipci on 2022-08-18.
//

import UIKit

class SearchStockViewController: UIViewController {
    
    // Search controller
    lazy var searchController = UISearchController(searchResultsController: addStockTableVC)
    lazy var addStockTableVC = self.storyboard?.instantiateViewController(withIdentifier: "addStockTableVC") as! AddStockTableViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

// Search Results
extension SearchStockViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        _ = ServiceManager.createRequest(route: .financeSearch(searchText), method: .get) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let company):
                self?.addStockTableVC.companyList = company ?? []
                DispatchQueue.main.async {
                    self?.addStockTableVC.tableView.reloadData()
                }
            }
        }
    }
}
// MARK: = protocol to get the company name
extension SearchStockViewController: TableStocksDelegate {
    func companySelected(data: CompanyDetail) {
        let cityName = data.name
        title = cityName
        print("Company selected")
        
        searchController.isActive = false
    }

}



