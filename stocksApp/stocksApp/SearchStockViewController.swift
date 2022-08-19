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



extension SearchStockViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            //let request = ServiceManager.createRequest(route: .financeSearch(searchText), method: .get)
//            ServiceManager.createRequest(route: .financeSearch(searchText), method: .get) { response, error in
//                print(response)
//            }
            ServiceManager.createRequest(route: .financeSearch(searchText), method: .get) { [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case.success(let stocks):
                    print(stocks)
                }
            
            }
            //print("The URL is : \(String(describing: request?.url))")
            
        }else if ((searchController.searchBar.text?.isEmpty) != nil) {
            print("Error at updateSearchResults")
        }
        self.addStockTableVC.tableView.reloadData()
        //self.searchCityTableVC.tableView.reloadData()
    }
}



